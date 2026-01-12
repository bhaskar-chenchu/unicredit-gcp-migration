# Packer Template - Windows Server 2022 with IIS and .NET
# UniCredit GCP Migration

packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

# Variables
variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "zone" {
  type        = string
  description = "GCP Zone for building the image"
  default     = "us-central1-a"
}

variable "source_image_family" {
  type        = string
  description = "Source image family"
  default     = "windows-2022"
}

variable "source_image_project" {
  type        = string
  description = "Source image project"
  default     = "windows-cloud"
}

variable "machine_type" {
  type        = string
  description = "Machine type for building"
  default     = "n2-standard-4"
}

variable "disk_size" {
  type        = number
  description = "Disk size in GB"
  default     = 100
}

variable "dotnet_version" {
  type        = string
  description = ".NET version (4.8 or 6 or 7 or 8)"
  default     = "4.8"
}

variable "image_name_prefix" {
  type        = string
  description = "Prefix for the image name"
  default     = "win2022-iis"
}

variable "image_family" {
  type        = string
  description = "Image family for the created image"
  default     = "win2022-iis"
}

variable "network" {
  type        = string
  description = "VPC network for building"
  default     = "default"
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork for building"
  default     = "default"
}

# Locals
locals {
  timestamp  = formatdate("YYYYMMDDhhmmss", timestamp())
  image_name = "${var.image_name_prefix}-dotnet${replace(var.dotnet_version, ".", "")}-${local.timestamp}"
}

# Source
source "googlecompute" "win2022" {
  project_id              = var.project_id
  zone                    = var.zone
  source_image_family     = var.source_image_family
  source_image_project_id = var.source_image_project
  machine_type            = var.machine_type
  disk_size               = var.disk_size
  disk_type               = "pd-ssd"

  image_name        = local.image_name
  image_family      = var.image_family
  image_description = "Windows Server 2022 with IIS and .NET ${var.dotnet_version}"
  image_labels = {
    os             = "windows2022"
    dotnet_version = replace(var.dotnet_version, ".", "-")
    created_by     = "packer"
  }

  network    = var.network
  subnetwork = var.subnetwork
  tags       = ["packer-build", "allow-rdp", "allow-winrm"]

  communicator   = "winrm"
  winrm_username = "packer_user"
  winrm_insecure = true
  winrm_use_ssl  = true

  metadata = {
    windows-startup-script-cmd = "winrm quickconfig -quiet & net user /add packer_user & net localgroup administrators packer_user /add & winrm set winrm/config/service/auth @{Basic=\"true\"}"
  }
}

# Build
build {
  sources = ["source.googlecompute.win2022"]

  # Install IIS
  provisioner "powershell" {
    inline = [
      "Write-Host 'Installing IIS...'",
      "Install-WindowsFeature -Name Web-Server -IncludeManagementTools",
      "Install-WindowsFeature -Name Web-Asp-Net45",
      "Install-WindowsFeature -Name Web-Net-Ext45",
      "Install-WindowsFeature -Name Web-ISAPI-Ext",
      "Install-WindowsFeature -Name Web-ISAPI-Filter",
      "Install-WindowsFeature -Name Web-Mgmt-Console",
      "Install-WindowsFeature -Name Web-Mgmt-Tools"
    ]
  }

  # Install .NET Framework 4.8
  provisioner "powershell" {
    inline = [
      "Write-Host 'Installing .NET Framework 4.8...'",
      "$url = 'https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe'",
      "$output = 'C:\\Windows\\Temp\\ndp48.exe'",
      "Invoke-WebRequest -Uri $url -OutFile $output",
      "Start-Process -FilePath $output -ArgumentList '/q /norestart' -Wait",
      "Remove-Item $output -Force"
    ]
  }

  # Install .NET 6/7/8 if requested
  provisioner "powershell" {
    inline = [
      "if ('${var.dotnet_version}' -match '^[678]$') {",
      "  Write-Host 'Installing .NET ${var.dotnet_version}...'",
      "  $dotnetVersion = '${var.dotnet_version}'",
      "  Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'C:\\Windows\\Temp\\dotnet-install.ps1'",
      "  & 'C:\\Windows\\Temp\\dotnet-install.ps1' -Channel $dotnetVersion.0 -Runtime aspnetcore -InstallDir 'C:\\Program Files\\dotnet'",
      "  & 'C:\\Windows\\Temp\\dotnet-install.ps1' -Channel $dotnetVersion.0 -InstallDir 'C:\\Program Files\\dotnet'",
      "  [Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\\Program Files\\dotnet', [EnvironmentVariableTarget]::Machine)",
      "  Remove-Item 'C:\\Windows\\Temp\\dotnet-install.ps1' -Force",
      "}"
    ]
  }

  # Configure IIS
  provisioner "powershell" {
    inline = [
      "Write-Host 'Configuring IIS...'",
      "Import-Module WebAdministration",
      "Set-WebConfigurationProperty -Filter /system.webServer/security/requestFiltering -Name allowDoubleEscaping -Value $true",
      "Set-ItemProperty 'IIS:\\AppPools\\DefaultAppPool' -Name processModel.identityType -Value 'ApplicationPoolIdentity'",
      "Set-ItemProperty 'IIS:\\AppPools\\DefaultAppPool' -Name managedRuntimeVersion -Value 'v4.0'"
    ]
  }

  # Create application directories
  provisioner "powershell" {
    inline = [
      "New-Item -ItemType Directory -Force -Path 'C:\\inetpub\\apps'",
      "New-Item -ItemType Directory -Force -Path 'C:\\logs\\iis'",
      "New-Item -ItemType Directory -Force -Path 'C:\\logs\\application'"
    ]
  }

  # Install SQL Server client tools
  provisioner "powershell" {
    inline = [
      "Write-Host 'Installing SQL Server client tools...'",
      "Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force",
      "Install-Module -Name SqlServer -Force -AllowClobber"
    ]
  }

  # Windows Update
  provisioner "powershell" {
    inline = [
      "Write-Host 'Installing Windows Updates...'",
      "Install-Module PSWindowsUpdate -Force",
      "Import-Module PSWindowsUpdate",
      "Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot"
    ]
  }

  # Cleanup
  provisioner "powershell" {
    inline = [
      "Write-Host 'Cleaning up...'",
      "Remove-Item -Path 'C:\\Windows\\Temp\\*' -Recurse -Force -ErrorAction SilentlyContinue",
      "Clear-RecycleBin -Force -ErrorAction SilentlyContinue",
      "Optimize-Volume -DriveLetter C -Defrag -ErrorAction SilentlyContinue"
    ]
  }

  # Sysprep
  provisioner "powershell" {
    inline = [
      "Write-Host 'Running Sysprep...'",
      "& 'C:\\Program Files\\Google\\Compute Engine\\sysprep\\gcesysprep.bat'"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
