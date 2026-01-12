# Windows Server 2022 Hardening - IIS Controls
# Based on CIS IIS Benchmark and security best practices

control 'win2022-iis-001' do
  impact 1.0
  title 'Ensure IIS is installed only on dedicated web servers'
  desc 'IIS should only be installed on dedicated web servers'
  tag 'iis'
  tag 'web-server'

  only_if('IIS is installed') do
    command('Get-WindowsFeature Web-Server').stdout.include?('Installed')
  end

  describe windows_feature('Web-Server') do
    it { should be_installed }
  end
end

control 'win2022-iis-002' do
  impact 1.0
  title 'Ensure IIS uses TLS 1.2 or higher'
  desc 'Weak TLS versions should be disabled'
  tag 'iis'
  tag 'tls'
  tag 'cis-benchmark'

  only_if('IIS is installed') do
    command('Get-WindowsFeature Web-Server').stdout.include?('Installed')
  end

  # TLS 1.0 should be disabled
  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\\TLS 1.0\\Server') do
    its('Enabled') { should eq 0 }
  end

  # TLS 1.1 should be disabled
  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\\TLS 1.1\\Server') do
    its('Enabled') { should eq 0 }
  end

  # TLS 1.2 should be enabled
  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\\TLS 1.2\\Server') do
    its('Enabled') { should eq 1 }
  end
end

control 'win2022-iis-003' do
  impact 0.7
  title 'Ensure SSL 2.0 and SSL 3.0 are disabled'
  desc 'Legacy SSL protocols should be disabled'
  tag 'iis'
  tag 'ssl'
  tag 'cis-benchmark'

  only_if('IIS is installed') do
    command('Get-WindowsFeature Web-Server').stdout.include?('Installed')
  end

  # SSL 2.0 should be disabled
  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\\SSL 2.0\\Server') do
    its('Enabled') { should eq 0 }
  end

  # SSL 3.0 should be disabled
  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\\SSL 3.0\\Server') do
    its('Enabled') { should eq 0 }
  end
end

control 'win2022-iis-004' do
  impact 1.0
  title 'Ensure Directory browsing is disabled'
  desc 'Directory browsing should be disabled to prevent information disclosure'
  tag 'iis'
  tag 'cis-benchmark'

  only_if('IIS is installed') do
    command('Get-WindowsFeature Web-Server').stdout.include?('Installed')
  end

  describe command('(Get-WebConfigurationProperty -Filter system.webServer/directoryBrowse -Name enabled).Value') do
    its('stdout.strip') { should eq 'False' }
  end
end

control 'win2022-iis-005' do
  impact 0.7
  title 'Ensure custom error pages are configured'
  desc 'Custom error pages prevent information disclosure'
  tag 'iis'
  tag 'cis-benchmark'

  only_if('IIS is installed') do
    command('Get-WindowsFeature Web-Server').stdout.include?('Installed')
  end

  describe command('(Get-WebConfigurationProperty -Filter system.webServer/httpErrors -Name errorMode).Value') do
    its('stdout.strip') { should eq 'Custom' }
  end
end

control 'win2022-iis-006' do
  impact 1.0
  title 'Ensure application pool identity is configured correctly'
  desc 'Application pools should not run as LocalSystem'
  tag 'iis'
  tag 'cis-benchmark'

  only_if('IIS is installed') do
    command('Get-WindowsFeature Web-Server').stdout.include?('Installed')
  end

  describe command('Get-IISAppPool | Where-Object {$_.ProcessModel.IdentityType -eq "LocalSystem"} | Measure-Object | Select-Object -ExpandProperty Count') do
    its('stdout.to_i') { should eq 0 }
  end
end

control 'win2022-iis-007' do
  impact 1.0
  title 'Ensure HSTS is enabled'
  desc 'HTTP Strict Transport Security should be enabled'
  tag 'iis'
  tag 'hsts'

  only_if('IIS is installed') do
    command('Get-WindowsFeature Web-Server').stdout.include?('Installed')
  end

  describe command('(Get-WebConfigurationProperty -Filter system.webServer/httpProtocol/customHeaders -Name collection | Where-Object {$_.name -eq "Strict-Transport-Security"}) -ne $null') do
    its('stdout.strip') { should eq 'True' }
  end
end

control 'win2022-iis-008' do
  impact 0.7
  title 'Ensure X-Content-Type-Options header is set'
  desc 'X-Content-Type-Options should be set to nosniff'
  tag 'iis'
  tag 'headers'

  only_if('IIS is installed') do
    command('Get-WindowsFeature Web-Server').stdout.include?('Installed')
  end

  describe command('Get-WebConfigurationProperty -Filter system.webServer/httpProtocol/customHeaders -Name collection | Where-Object {$_.name -eq "X-Content-Type-Options" -and $_.value -eq "nosniff"}') do
    its('stdout') { should_not be_empty }
  end
end

control 'win2022-iis-009' do
  impact 0.7
  title 'Ensure X-Frame-Options header is set'
  desc 'X-Frame-Options should be set to prevent clickjacking'
  tag 'iis'
  tag 'headers'

  only_if('IIS is installed') do
    command('Get-WindowsFeature Web-Server').stdout.include?('Installed')
  end

  describe command('Get-WebConfigurationProperty -Filter system.webServer/httpProtocol/customHeaders -Name collection | Where-Object {$_.name -eq "X-Frame-Options"}') do
    its('stdout') { should_not be_empty }
  end
end

control 'win2022-iis-010' do
  impact 1.0
  title 'Ensure IIS logging is enabled'
  desc 'IIS request logging should be enabled for all sites'
  tag 'iis'
  tag 'logging'

  only_if('IIS is installed') do
    command('Get-WindowsFeature Web-Server').stdout.include?('Installed')
  end

  describe command('Get-Website | Where-Object {$_.logFile.enabled -eq $false} | Measure-Object | Select-Object -ExpandProperty Count') do
    its('stdout.to_i') { should eq 0 }
  end
end
