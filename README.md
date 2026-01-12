# UniCredit GCP Cloud Migration

System Integrator Evaluation - Large-Scale Cloud Migration to GCP

## Project Overview

This repository contains the infrastructure code, configuration management, and application deployment artifacts for UniCredit's cloud migration proof-of-concept. The project demonstrates migration capabilities from legacy technology stacks to modern versions on Google Cloud Platform.

### Applications

| Application | Legacy Stack | Modern Stack |
|-------------|--------------|--------------|
| **App A** (Java) | RHEL 7, JBoss 7, Java 8, PostgreSQL 9.6/10 | RHEL 9, WildFly 30+, Java 17/21, PostgreSQL 15/16 |
| **App B** (.NET) | Windows Server 2012/2016, .NET 4.5/4.6, SQL Server 2014/2016 | Windows Server 2022, .NET 4.8/.NET 6+, SQL Server 2019/2022 |

## Repository Structure

```
├── terraform/                    # Infrastructure as Code
│   ├── modules/                  # Reusable Terraform modules
│   │   ├── compute/              # Compute Engine instance groups
│   │   ├── cloudsql/             # Cloud SQL (PostgreSQL, SQL Server)
│   │   ├── network/              # VPC, subnets, firewall, NAT
│   │   ├── iam/                  # IAM roles and service accounts
│   │   └── load-balancer/        # HTTP(S) load balancer
│   ├── environments/             # Environment-specific configurations
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   └── tests/                    # Terratest configurations
├── packer/                       # Image building
│   ├── linux/
│   │   └── rhel9/                # RHEL 9 with WildFly 30+
│   └── windows/
│       └── win2022/              # Windows Server 2022 with IIS
├── ansible/                      # Configuration management
│   ├── roles/                    # Ansible roles
│   ├── playbooks/
│   │   ├── linux-modern/         # WildFly configuration
│   │   └── windows-modern/       # IIS configuration
│   └── inventory/                # Environment inventories
├── applications/                 # Application source code
│   ├── app-a/
│   │   ├── legacy-src/           # Java 8 + JBoss 7
│   │   ├── modern-src/           # Java 17/21 + WildFly 30+
│   │   └── migration/            # Migration scripts & docs
│   └── app-b/
│       ├── legacy-src/           # .NET 4.5/4.6
│       ├── modern-src/           # .NET 4.8 or .NET 6+
│       └── migration/            # Migration scripts & docs
├── jenkins/
│   └── pipelines/                # CI/CD pipeline definitions
├── tests/                        # Testing frameworks
│   ├── terratest/                # Infrastructure tests
│   ├── molecule/                 # Ansible role tests
│   └── inspec/                   # Compliance tests
└── docs/                         # Documentation
    ├── architecture/             # Architecture diagrams
    ├── runbooks/                 # Operations runbooks
    ├── test-reports/             # Test execution reports
    └── migration/                # Migration guides
```

## Prerequisites

### Required Tools
- Terraform >= 1.5.0
- Packer >= 1.9.0
- Ansible >= 2.15.0
- Go >= 1.21 (for Terratest)
- Python >= 3.10
- Google Cloud SDK
- Jenkins (for CI/CD)

### GCP Setup
1. GCP Project with billing enabled
2. Service account with appropriate permissions
3. APIs enabled: Compute Engine, Cloud SQL, IAM, Cloud Monitoring

## Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/sudhakarkr/unicredit-gcp-migration.git
cd unicredit-gcp-migration
```

### 2. Configure GCP Credentials
```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
```

### 3. Initialize Terraform
```bash
cd terraform/environments/dev
terraform init
terraform plan
```

### 4. Build Packer Images
```bash
cd packer/linux/rhel9
packer init .
packer build .
```

### 5. Run Ansible Playbooks
```bash
cd ansible
ansible-playbook -i inventory/dev playbooks/linux-modern/deploy.yml
```

## Deployment Instructions

### Application A - Legacy Stack (Week 1)
See [docs/runbooks/app-a-legacy-deployment.md](docs/runbooks/app-a-legacy-deployment.md)

### Application A - Modern Stack (Weeks 2-3)
See [docs/runbooks/app-a-modern-deployment.md](docs/runbooks/app-a-modern-deployment.md)

### Application B - Legacy Stack (Week 1)
See [docs/runbooks/app-b-legacy-deployment.md](docs/runbooks/app-b-legacy-deployment.md)

### Application B - Modern Stack (Weeks 2-3)
See [docs/runbooks/app-b-modern-deployment.md](docs/runbooks/app-b-modern-deployment.md)

## Migration Execution Guide

### Application A Migration
1. Verify legacy application is functional
2. Export data from PostgreSQL 9.6/10
3. Deploy modern infrastructure with Terraform
4. Run database migration scripts
5. Deploy modernized application
6. Verify data integrity and functionality

See [docs/migration/app-a-migration-guide.md](docs/migration/app-a-migration-guide.md)

### Application B Migration
1. Verify legacy application is functional
2. Export data from SQL Server 2014/2016
3. Deploy modern infrastructure with Terraform
4. Run database migration scripts
5. Deploy modernized application
6. Verify data integrity and functionality

See [docs/migration/app-b-migration-guide.md](docs/migration/app-b-migration-guide.md)

## Testing

### Infrastructure Tests (Terratest)
```bash
cd terraform/tests
go test -v ./...
```

### Configuration Tests (Molecule)
```bash
cd ansible/roles/<role-name>
molecule test
```

### Compliance Tests (InSpec)
```bash
inspec exec tests/inspec/cis-rhel9 -t ssh://user@host
inspec exec tests/inspec/cis-windows --target winrm://user@host
```

## Architecture Documentation

- [GCP Landing Zone Architecture](docs/architecture/landing-zone.md)
- [Network Topology](docs/architecture/network.md)
- [Application A Architecture](docs/architecture/app-a.md)
- [Application B Architecture](docs/architecture/app-b.md)

## Troubleshooting

See [docs/runbooks/troubleshooting.md](docs/runbooks/troubleshooting.md)

## Project Timeline

| Week | Focus | Key Deliverables |
|------|-------|------------------|
| 1 | Foundation & Legacy | Gap Analysis, GCP setup, Legacy deployments |
| 2 | Infrastructure & Prep | Terraform, Packer, Ansible, Migration prep |
| 3 | Migration & Validation | Complete migrations, Testing, Documentation |

## Contact

- Project Repository: https://github.com/sudhakarkr/unicredit-gcp-migration
- Issues: https://github.com/sudhakarkr/unicredit-gcp-migration/issues
