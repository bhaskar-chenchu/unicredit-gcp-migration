# UniCredit Cloud Migration Challenge - Project Memory

## Project Overview
- **Project**: System Integrator Evaluation for Large-Scale Cloud Migration to GCP
- **Organization**: UniCredit
- **Duration**: 3 Weeks
- **Repository**: UniCredit Bitbucket (daily commits required)
- **Version**: 2.0 (Migration Enhanced)

## Evaluation Areas & Weights

### Dimension 1: Onboarding & Context (40% of total)
- Onboarding Speed (35%)
- Context Understanding (40%)
- Stakeholder Engagement (25%)

### Dimension 2: Technical Proficiency (60% of total)
- Infrastructure as Code - Terraform (20% of Dim 2 = 12% total)
- Configuration Management - Ansible & Packer (20% of Dim 2 = 12% total)
- Cloud Architecture & Design (20% of Dim 2 = 12% total)
- Testing & Quality (20% of Dim 2 = 12% total)
- Migration Capability (20% of Dim 2 = 12% total)

## Key Deliverables

### Week 1
1. Gap Analysis Document (complete)
2. GCP Landing Zone setup (start)
3. Application A deployed on legacy stack (RHEL 7, JBoss 7, Java 8)
4. Application B deployed on legacy stack (Windows Server 2012/2016, .NET 4.5/4.6)
5. UniCredit verification of legacy apps

### Week 2
1. Packer images for modern stacks
2. Terraform modules for modern infrastructure
3. Application code updates for modern versions
4. Ansible playbooks for configuration
5. Database migration preparation
6. Start Application A migration

### Week 3
1. Complete Application A migration
2. Complete Application B migration
3. Execute all testing phases
4. CIS Level 1 hardening
5. UniCredit verification of migrated apps
6. All documentation and test reports

## Applications

### Application A: Linux/Java
**Legacy Stack (Phase 1)**
- OS: RHEL 7.x / CentOS 7.x / Ubuntu 18.04 LTS
- App Server: JBoss EAP 7.x / WildFly 10.x-14.x
- Java: OpenJDK 8 / Oracle JDK 8
- DB: PostgreSQL 9.6 / 10.x

**Modern Stack (Phase 2)**
- OS: RHEL 9.x / Rocky Linux 9.x / AlmaLinux 9.x / Ubuntu 22.04/24.04
- App Server: WildFly 30.x+ / JBoss EAP 8.x
- Java: OpenJDK 17 LTS / OpenJDK 21 LTS
- DB: PostgreSQL 15.x / 16.x

**Suggested Apps**: Ticket Monster, Petclinic, Kitchensink, or custom CRUD app

### Application B: Windows/.NET
**Legacy Stack (Phase 1)**
- OS: Windows Server 2012 R2 / 2016
- Runtime: .NET Framework 4.5 / 4.6
- Web Server: IIS 8.5 / 10
- DB: SQL Server 2014 / 2016 (or PostgreSQL 9.6)

**Modern Stack (Phase 2)**
- OS: Windows Server 2022 / 2019
- Runtime: .NET Framework 4.8 / .NET 6/7/8
- Web Server: IIS 10 (latest patches)
- DB: SQL Server 2019 / 2022

## Required Tools & Technologies
- **IaC**: Terraform (modules, state management, Terratest, Checkov)
- **Configuration**: Ansible (roles, playbooks, Molecule), Packer (images)
- **CI/CD**: Jenkins (pipelines, triggers, rollback)
- **Testing**: Terratest, Checkov, Molecule, InSpec, load testing, resiliency testing
- **Cloud**: GCP (Compute Engine, Cloud SQL, VPC, IAM, Cloud Monitoring)

## Minimum Acceptance Criteria
- Overall Score: 3.0 / 5.0
- Dimension 1 Score: 2.5 / 5.0
- Dimension 2 Score: 3.0 / 5.0
- Migration Capability Score: 3.0 / 5.0 (mandatory)
- Both apps deployed on legacy AND migrated to modern stacks
- Data integrity: Week 1 test data preserved after migration

## Repository Structure Required
```
├── terraform/
│   ├── modules/
│   ├── environments/
│   └── tests/
├── packer/
│   ├── linux/
│   └── windows/
├── ansible/
│   ├── roles/
│   ├── playbooks/
│   └── inventory/
├── applications/
│   ├── app-a/
│   │   ├── legacy-src/
│   │   ├── modern-src/
│   │   └── migration/
│   └── app-b/
│       ├── legacy-src/
│       ├── modern-src/
│       └── migration/
├── jenkins/
│   └── pipelines/
├── tests/
│   ├── terratest/
│   ├── molecule/
│   └── inspec/
├── docs/
│   ├── architecture/
│   ├── runbooks/
│   ├── test-reports/
│   └── migration/
└── README.md
```

## Document Paths
- Requirements: `/Users/sudhakarkr/coding/2026/unicredit/migrationchallenge/System_Integrator_Evaluation_Framework.md`
- Plan: `/Users/sudhakarkr/coding/2026/unicredit/migrationchallenge/PROJECT_PLAN.md`

## GitHub Repository
- URL: https://github.com/sudhakarkr/unicredit-gcp-migration
- Visibility: Private
- Issues: 64 total (all created)
- Milestones: 3 (Week 1, Week 2, Week 3)

## Labels Created
### Epic Labels
- epic:project-setup
- epic:gap-analysis
- epic:app-a-legacy
- epic:app-b-legacy
- epic:infrastructure
- epic:packer
- epic:ansible
- epic:app-a-migration
- epic:app-b-migration
- epic:testing
- epic:documentation
- epic:cicd

### Priority Labels
- priority:critical
- priority:high
- priority:medium

### Week Labels
- week:1
- week:2
- week:3

## Issue Summary by Epic
| Epic | Issues | Week |
|------|--------|------|
| Project Setup | #1-4 | 1 |
| Gap Analysis | #5-8 | 1 |
| App A Legacy | #9-12 | 1 |
| App B Legacy | #13-16 | 1 |
| Infrastructure (Terraform) | #17-23 | 2 |
| Packer | #24-27 | 2 |
| Ansible | #28-34 | 2 |
| App A Migration | #35-41 | 2-3 |
| App B Migration | #42-48 | 2-3 |
| Testing | #49-54 | 3 |
| Documentation | #55-59 | 2-3 |
| CI/CD | #60-64 | 2-3 |
