# Coding Agent Task Analysis

This document categorizes all project issues by what can be done by a coding agent vs. manual work.

---

## Fully Automatable by Coding Agent

These tasks involve writing code, configurations, and documentation that can be done entirely by an AI coding agent.

### Infrastructure as Code (Terraform)
| Issue | Title | Agent Task |
|-------|-------|------------|
| #17 | Create Terraform module for Compute Engine instance groups | Write Terraform HCL code |
| #18 | Create Terraform module for Cloud SQL | Write Terraform HCL code |
| #19 | Create Terraform module for networking | Write Terraform HCL code |
| #20 | Create Terraform module for IAM and service accounts | Write Terraform HCL code |
| #21 | Configure Terraform remote state with GCS backend | Write backend configuration |
| #22 | Implement Terratest for all modules | Write Go test code |
| #23 | Configure Checkov policy scanning | Write CI configuration |

### Image Building (Packer)
| Issue | Title | Agent Task |
|-------|-------|------------|
| #24 | Create RHEL 9 base image with Java 17/21 and WildFly 30+ | Write Packer HCL template |
| #25 | Apply CIS Level 1 hardening to RHEL 9 image | Write hardening scripts/config |
| #26 | Create Windows Server 2022 base image | Write Packer HCL template |
| #27 | Apply CIS Level 1 hardening to Windows Server | Write hardening scripts/config |

### Configuration Management (Ansible)
| Issue | Title | Agent Task |
|-------|-------|------------|
| #28 | Create Ansible role for WildFly configuration | Write Ansible roles/playbooks |
| #29 | Create Ansible role for PostgreSQL client | Write Ansible roles/playbooks |
| #30 | Create Ansible role for Java app deployment | Write Ansible roles/playbooks |
| #31 | Create Ansible role for IIS configuration | Write Ansible roles/playbooks |
| #32 | Create Ansible role for SQL Server client | Write Ansible roles/playbooks |
| #33 | Create Ansible role for .NET app deployment | Write Ansible roles/playbooks |
| #34 | Implement Molecule tests for all Ansible roles | Write Molecule test configs |

### CI/CD Pipelines (Jenkins)
| Issue | Title | Agent Task |
|-------|-------|------------|
| #60 | Create Jenkins pipeline for Terraform validation | Write Jenkinsfile |
| #61 | Create Jenkins pipeline for Packer image builds | Write Jenkinsfile |
| #62 | Create Jenkins pipeline for Ansible deployment | Write Jenkinsfile |
| #63 | Create Jenkins pipeline for Application A build/deploy | Write Jenkinsfile |
| #64 | Create Jenkins pipeline for Application B build/deploy | Write Jenkinsfile |

### Application Code Migration
| Issue | Title | Agent Task |
|-------|-------|------------|
| #35 | Analyze Java 8 to Java 17/21 migration requirements | Code analysis, write report |
| #36 | Update Application A code for modern Java version | Modify Java source code |
| #42 | Analyze .NET 4.5/4.6 to 4.8/.NET 6+ migration requirements | Code analysis, write report |
| #43 | Update Application B code for modern .NET version | Modify .NET source code |

### Documentation
| Issue | Title | Agent Task |
|-------|-------|------------|
| #37 | Plan PostgreSQL 9.6/10 to 15/16 migration | Write migration plan document |
| #41 | Create Application A migration documentation | Write documentation |
| #44 | Plan SQL Server 2014/2016 to 2019/2022 migration | Write migration plan document |
| #48 | Create Application B migration documentation | Write documentation |
| #55 | Create architecture documentation with diagrams | Write docs, create diagram code |
| #56 | Create operations runbooks for Application A | Write runbook documents |
| #57 | Create operations runbooks for Application B | Write runbook documents |
| #59 | Update README with complete project documentation | Write README.md |

### Repository Setup
| Issue | Title | Agent Task |
|-------|-------|------------|
| #1 | Initialize repository with required structure | Create directory structure, files |

### Testing Code (Writing Tests)
| Issue | Title | Agent Task |
|-------|-------|------------|
| #22 | Implement Terratest for all modules | Write Go test code |
| #34 | Implement Molecule tests for all Ansible roles | Write test configurations |

**Total: 35 issues (55%) - Fully automatable**

---

## Partially Automatable (Agent + Human)

These tasks require coding agent work but also need human review, cloud credentials, or manual verification.

### Gap Analysis (Agent writes template, human fills content)
| Issue | Title | Agent Work | Human Work |
|-------|-------|------------|------------|
| #5 | Analyze GCP Landing Zone architecture | Create assessment template | Access GCP, review resources |
| #6 | Assess DevOps tooling and practices | Create assessment template | Interview teams, access tools |
| #7 | Evaluate team processes and ITSM | Create assessment template | Interview stakeholders |
| #8 | Create Gap Analysis Document | Write document structure | Fill findings from assessment |

### Infrastructure Setup (Agent writes code, human applies)
| Issue | Title | Agent Work | Human Work |
|-------|-------|------------|------------|
| #2 | Set up GCP project hierarchy | Write Terraform/gcloud scripts | Execute with credentials |
| #3 | Configure IAM roles and service accounts | Write Terraform code | Apply with admin access |
| #4 | Set up Jenkins CI/CD infrastructure | Write deployment scripts | Deploy and configure |

### Database Migration Planning
| Issue | Title | Agent Work | Human Work |
|-------|-------|------------|------------|
| #37 | Plan PostgreSQL migration | Write migration scripts | Test on live DB |
| #44 | Plan SQL Server migration | Write migration scripts | Test on live DB |

### Test Report Compilation
| Issue | Title | Agent Work | Human Work |
|-------|-------|------------|------------|
| #49 | Document infrastructure tests | Create report template | Run tests, fill results |
| #50 | Document configuration tests | Create report template | Run tests, fill results |
| #51 | Document functional tests | Create test scripts | Execute and document |
| #52 | Document performance tests | Create test scripts | Execute and document |
| #53 | Document resiliency tests | Create test procedures | Execute and document |
| #54 | Validate data integrity | Write validation queries | Execute and verify |
| #58 | Compile all test reports | Aggregate and format | Review and finalize |

**Total: 17 issues (27%) - Partially automatable**

---

## Manual / Cloud Access Required

These tasks require direct cloud access, manual deployment, or human verification.

### Legacy Application Deployment
| Issue | Title | Why Manual |
|-------|-------|------------|
| #65 | Deploy RHEL 7/CentOS 7 VMs | Requires GCP console/CLI access |
| #9 | Configure Cloud SQL PostgreSQL 9.6/10 | Requires GCP access |
| #10 | Install JBoss EAP 7.x with Java 8 | Requires SSH to VMs |
| #11 | Deploy and verify Application A on legacy | Requires deployment access |
| #13 | Deploy Windows Server 2012/2016 VMs | Requires GCP access |
| #14 | Configure Cloud SQL SQL Server | Requires GCP access |
| #15 | Install IIS and .NET Framework | Requires RDP to VMs |
| #16 | Deploy and verify Application B on legacy | Requires deployment access |

### Modern Infrastructure Deployment
| Issue | Title | Why Manual |
|-------|-------|------------|
| #38 | Deploy modern infrastructure for Application A | Terraform apply needs credentials |
| #39 | Execute database migration for Application A | Requires DB access |
| #40 | Deploy and verify Application A on modern stack | Requires deployment + UniCredit verification |
| #45 | Deploy modern infrastructure for Application B | Terraform apply needs credentials |
| #46 | Execute database migration for Application B | Requires DB access |
| #47 | Deploy and verify Application B on modern stack | Requires deployment + UniCredit verification |

**Total: 12 issues (18%) - Manual required**

---

## Summary

| Category | Issue Count | Percentage |
|----------|-------------|------------|
| Fully Automatable by Agent | 35 | 55% |
| Partially Automatable | 17 | 27% |
| Manual / Cloud Access Required | 12 | 18% |
| **Total** | **64** | **100%** |

---

## Recommended Agent Workflow

### Phase 1: Agent Creates All Code Artifacts
The agent can immediately start working on:
1. Repository structure (#1)
2. All Terraform modules (#17-23)
3. All Packer templates (#24-27)
4. All Ansible roles (#28-34)
5. All Jenkins pipelines (#60-64)
6. Documentation templates (#55-59)
7. Migration analysis and code updates (#35-36, #42-43)

### Phase 2: Human Reviews and Deploys
Human takes agent output and:
1. Reviews code for correctness
2. Applies Terraform with credentials
3. Builds Packer images
4. Runs Ansible playbooks
5. Deploys applications
6. Executes tests

### Phase 3: Agent Documents Results
Agent can:
1. Format test reports
2. Update documentation with results
3. Create final deliverables

---

## Agent Task Prioritization

### High Priority (Start Immediately)
1. #1 - Repository structure
2. #17-19 - Core Terraform modules
3. #24, #26 - Packer base images
4. #28, #30, #31, #33 - Core Ansible roles
5. #35, #42 - Migration analysis

### Medium Priority (Week 2)
6. #20-23 - Supporting Terraform
7. #25, #27 - CIS hardening
8. #29, #32, #34 - Supporting Ansible
9. #36, #43 - Code migration
10. #60-64 - Jenkins pipelines

### Lower Priority (After Infrastructure)
11. #37, #44 - DB migration plans
12. #41, #48, #55-59 - Documentation
