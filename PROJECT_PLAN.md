# UniCredit Cloud Migration Challenge - Project Plan

## Executive Summary

This plan outlines the implementation approach for the UniCredit System Integrator Evaluation, a 3-week proof-of-concept demonstrating cloud migration capabilities to GCP. The project consists of two evaluation areas weighted at 40% (Onboarding & Assessment) and 60% (Technical Proficiency).

**Key Success Factors:**
- Daily commits to repository
- Both applications functional on legacy stacks by end of Week 1
- Both applications successfully migrated to modern stacks by end of Week 3
- Complete test coverage and documentation
- Data integrity preservation

---

## Week 1: Foundation & Legacy Deployment

### Phase 1.1: Project Setup & Onboarding (Days 1-2)

#### Tasks:
1. **Repository Initialization**
   - Create repository structure per requirements
   - Set up branching strategy (main, develop, feature branches)
   - Configure commit hooks and PR templates
   - Initialize README with project overview

2. **GCP Environment Setup**
   - Create GCP organization/project structure (dev/staging/prod)
   - Configure IAM roles and service accounts
   - Set up networking baseline (VPC, subnets, firewall rules)
   - Enable required APIs

3. **Development Environment**
   - Configure local development tools (Terraform, Ansible, Packer)
   - Set up Jenkins server or use GCP Cloud Build initially
   - Establish access patterns and credentials management

### Phase 1.2: As-Is Assessment (Days 2-4)

#### Tasks:
4. **GCP Landing Zone Analysis**
   - Review multi-project structure and organization policies
   - Analyze VPC design, subnet allocation, firewall rules
   - Assess IAM policies, service accounts, workload identity
   - Evaluate security controls (Security Command Center, Cloud Armor, KMS)

5. **DevOps & Operations Assessment**
   - Analyze existing CI/CD pipelines (Jenkins)
   - Review Terraform usage and state management
   - Assess Ansible playbooks and role organization
   - Evaluate monitoring and observability setup

6. **Gap Analysis Document Creation**
   - Document findings with severity ratings
   - Categorize gaps (Critical/High/Medium/Low)
   - Provide remediation recommendations
   - Assess migration velocity impact

### Phase 1.3: Legacy Application Deployment (Days 3-5)

#### Application A - Legacy Stack:
7. **Infrastructure Setup**
   - Deploy RHEL 7 / CentOS 7 VMs on GCP Compute Engine
   - Configure Cloud SQL for PostgreSQL 9.6/10
   - Set up basic load balancer
   - Configure multi-AZ deployment (minimum 2 zones)

8. **Application A Deployment**
   - Select/build Java application (Petclinic, Kitchensink, or custom)
   - Install JBoss EAP 7.x / WildFly 10-14 with Java 8
   - Configure datasources and deploy application
   - Verify CRUD operations work

#### Application B - Legacy Stack:
9. **Infrastructure Setup**
   - Deploy Windows Server 2012 R2 / 2016 VMs
   - Configure Cloud SQL for SQL Server 2014/2016
   - Set up basic load balancer
   - Configure multi-AZ deployment

10. **Application B Deployment**
    - Select/build .NET Framework 4.5/4.6 application
    - Install IIS 8.5/10 and configure application pool
    - Deploy ASP.NET application
    - Verify CRUD operations work

### Week 1 Deliverables:
- [ ] Gap Analysis Document
- [ ] Repository initialized with proper structure
- [ ] Basic GCP landing zone configured
- [ ] Application A functional on legacy stack (accessible for UniCredit testing)
- [ ] Application B functional on legacy stack (accessible for UniCredit testing)

---

## Week 2: Migration Preparation & Infrastructure Modernization

### Phase 2.1: Modern Infrastructure Setup (Days 6-8)

#### Tasks:
11. **Terraform Module Development**
    - Create reusable modules for Compute Engine instance groups
    - Develop Cloud SQL modules with HA configuration
    - Build networking modules (VPC, subnets, firewall, NAT)
    - Implement IAM and service account modules
    - Configure remote state management (GCS backend)

12. **Terratest Implementation**
    - Write unit tests for Terraform modules
    - Implement integration tests
    - Configure CI/CD for Terraform validation

13. **Checkov Policy Integration**
    - Set up Checkov scanning in CI/CD
    - Address security and compliance findings
    - Document policy exceptions if needed

### Phase 2.2: Image Building with Packer (Days 7-9)

#### Application A Images:
14. **RHEL 9 Base Image**
    - Create Packer template for RHEL 9 / Rocky Linux 9
    - Install OpenJDK 17/21 and WildFly 30+
    - Apply CIS Level 1 hardening
    - Store in Compute Engine custom images

#### Application B Images:
15. **Windows Server 2022 Base Image**
    - Create Packer template for Windows Server 2022/2019
    - Install .NET Framework 4.8 / .NET 6+
    - Configure IIS 10
    - Apply CIS Level 1 hardening

### Phase 2.3: Configuration Management with Ansible (Days 8-10)

#### Tasks:
16. **Ansible Role Development - Linux**
    - WildFly configuration role (datasources, deployment, tuning)
    - PostgreSQL client configuration role
    - Application deployment automation role
    - Security hardening role

17. **Ansible Role Development - Windows**
    - IIS configuration role (app pools, sites, bindings)
    - SQL Server client configuration role
    - .NET application deployment role
    - Windows security hardening role

18. **Molecule Testing**
    - Create Molecule test scenarios for all roles
    - Test Linux roles with Docker/Vagrant
    - Test Windows roles with appropriate driver
    - Integrate with CI/CD

### Phase 2.4: Application Migration Preparation (Days 8-10)

#### Application A:
19. **Code Migration Analysis**
    - Identify Java 8 → 17/21 breaking changes
    - Update deprecated API usage
    - Modify Maven/Gradle configurations
    - Update dependency versions

20. **Database Migration Planning**
    - Plan PostgreSQL 9.6/10 → 15/16 upgrade
    - Identify schema compatibility issues
    - Create data migration scripts
    - Plan rollback procedures

#### Application B:
21. **Code Migration Analysis**
    - Identify .NET 4.5/4.6 → 4.8/.NET 6+ breaking changes
    - Update NuGet packages
    - Modify web.config / appsettings
    - Address deprecated patterns

22. **Database Migration Planning**
    - Plan SQL Server 2014/2016 → 2019/2022 upgrade
    - Identify compatibility issues
    - Create migration scripts
    - Plan rollback procedures

### Week 2 Deliverables:
- [ ] Terraform modules with tests (Terratest, Checkov)
- [ ] Packer images for RHEL 9 and Windows Server 2022
- [ ] Ansible roles with Molecule tests
- [ ] Migration planning documents for both applications
- [ ] Application A migration in progress
- [ ] Daily commits showing progress

---

## Week 3: Migration Execution & Validation

### Phase 3.1: Application A Migration (Days 11-13)

#### Tasks:
23. **Modern Infrastructure Deployment**
    - Deploy RHEL 9 instance groups using Terraform
    - Configure Cloud SQL PostgreSQL 15/16 with HA
    - Set up load balancer with health checks
    - Configure networking and firewall rules

24. **Database Migration**
    - Export data from legacy PostgreSQL
    - Apply schema updates for PostgreSQL 15/16
    - Import data with validation
    - Verify UniCredit test data preserved

25. **Application Deployment**
    - Deploy modernized Java application
    - Configure WildFly 30+ via Ansible
    - Test CRUD operations
    - Verify all functionality works

### Phase 3.2: Application B Migration (Days 12-14)

#### Tasks:
26. **Modern Infrastructure Deployment**
    - Deploy Windows Server 2022 instance groups
    - Configure Cloud SQL SQL Server 2019/2022 with HA
    - Set up load balancer with health checks
    - Configure networking and firewall rules

27. **Database Migration**
    - Export data from legacy SQL Server
    - Apply compatibility updates
    - Import data with validation
    - Verify UniCredit test data preserved

28. **Application Deployment**
    - Deploy modernized .NET application
    - Configure IIS via Ansible
    - Test CRUD operations
    - Verify all functionality works

### Phase 3.3: Testing & Validation (Days 13-15)

#### Infrastructure Tests:
29. **Terraform Validation**
    - Execute Terratest suite
    - Run Checkov policy scans
    - Validate terraform plan outputs
    - Generate test reports

#### Configuration Tests:
30. **Ansible Validation**
    - Execute Molecule test suite
    - Run InSpec compliance scans
    - Validate CIS Level 1 compliance
    - Generate test reports

#### Functional Tests:
31. **Application Testing**
    - Verify both applications accessible
    - Test CRUD operations
    - Validate database connectivity
    - Test authentication (if applicable)

#### Performance Tests:
32. **Load Testing**
    - Execute load tests on both applications
    - Measure requests per second, response times
    - Document resource utilization
    - Compare legacy vs modern performance

#### Resiliency Tests:
33. **Failover Testing**
    - Simulate AZ failure scenarios
    - Test database failover (Cloud SQL HA)
    - Measure RTO/RPO
    - Document recovery procedures

#### Migration Validation:
34. **Data Integrity Verification**
    - Verify Week 1 test data accessible in both apps
    - Validate data consistency
    - Document any discrepancies

### Phase 3.4: Documentation & Finalization (Days 14-15)

#### Tasks:
35. **Migration Documentation**
    - Application A migration guide
    - Application B migration guide
    - Lessons learned documentation
    - Code change documentation

36. **Test Reports**
    - Compile all test results
    - Create summary reports
    - Document any issues and resolutions

37. **Runbooks**
    - Operations and maintenance guides
    - Troubleshooting guides
    - Rollback procedures

38. **Final Repository Cleanup**
    - Ensure all code is documented
    - Update README with complete instructions
    - Verify all required files present

### Week 3 Deliverables:
- [ ] Application A migrated and functional on modern stack
- [ ] Application B migrated and functional on modern stack
- [ ] Week 1 test data preserved and accessible
- [ ] All test reports (infrastructure, config, functional, performance, resiliency)
- [ ] Complete migration documentation
- [ ] Runbooks for both applications
- [ ] CIS Level 1 compliance verified

---

## GitHub Issues Structure

The following issues should be created in the GitHub repository, organized by Epic/Label:

### Epic: Project Setup
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 1 | Initialize repository with required structure | High | 1 |
| 2 | Set up GCP project hierarchy (dev/staging/prod) | High | 1 |
| 3 | Configure IAM roles and service accounts | High | 1 |
| 4 | Set up Jenkins CI/CD infrastructure | Medium | 1 |

### Epic: Gap Analysis (Evaluation Area 1)
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 5 | Analyze GCP Landing Zone architecture | High | 1 |
| 6 | Assess DevOps tooling and practices | High | 1 |
| 7 | Evaluate team processes and ITSM | High | 1 |
| 8 | Create Gap Analysis Document | Critical | 1 |

### Epic: Application A - Legacy Deployment
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 9 | Deploy RHEL 7/CentOS 7 VMs for Application A | High | 1 |
| 10 | Configure Cloud SQL PostgreSQL 9.6/10 | High | 1 |
| 11 | Install JBoss EAP 7.x with Java 8 | High | 1 |
| 12 | Deploy and verify Application A on legacy stack | Critical | 1 |

### Epic: Application B - Legacy Deployment
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 13 | Deploy Windows Server 2012/2016 VMs for Application B | High | 1 |
| 14 | Configure Cloud SQL SQL Server 2014/2016 | High | 1 |
| 15 | Install IIS and .NET Framework 4.5/4.6 | High | 1 |
| 16 | Deploy and verify Application B on legacy stack | Critical | 1 |

### Epic: Infrastructure as Code
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 17 | Create Terraform module for Compute Engine instance groups | High | 2 |
| 18 | Create Terraform module for Cloud SQL (PostgreSQL, SQL Server) | High | 2 |
| 19 | Create Terraform module for networking (VPC, subnets, firewall) | High | 2 |
| 20 | Create Terraform module for IAM and service accounts | Medium | 2 |
| 21 | Configure Terraform remote state with GCS backend | Medium | 2 |
| 22 | Implement Terratest for all modules | High | 2 |
| 23 | Configure Checkov policy scanning | Medium | 2 |

### Epic: Image Building (Packer)
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 24 | Create RHEL 9 base image with Java 17/21 and WildFly 30+ | High | 2 |
| 25 | Apply CIS Level 1 hardening to RHEL 9 image | Medium | 2 |
| 26 | Create Windows Server 2022 base image with .NET and IIS | High | 2 |
| 27 | Apply CIS Level 1 hardening to Windows Server image | Medium | 2 |

### Epic: Configuration Management (Ansible)
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 28 | Create Ansible role for WildFly configuration | High | 2 |
| 29 | Create Ansible role for PostgreSQL client | Medium | 2 |
| 30 | Create Ansible role for Java app deployment | High | 2 |
| 31 | Create Ansible role for IIS configuration | High | 2 |
| 32 | Create Ansible role for SQL Server client | Medium | 2 |
| 33 | Create Ansible role for .NET app deployment | High | 2 |
| 34 | Implement Molecule tests for all Ansible roles | High | 2 |

### Epic: Application A - Migration
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 35 | Analyze Java 8 to Java 17/21 migration requirements | High | 2 |
| 36 | Update Application A code for modern Java version | High | 2 |
| 37 | Plan PostgreSQL 9.6/10 to 15/16 migration | High | 2 |
| 38 | Deploy modern infrastructure for Application A | Critical | 3 |
| 39 | Execute database migration for Application A | Critical | 3 |
| 40 | Deploy and verify Application A on modern stack | Critical | 3 |
| 41 | Create Application A migration documentation | High | 3 |

### Epic: Application B - Migration
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 42 | Analyze .NET 4.5/4.6 to 4.8/.NET 6+ migration requirements | High | 2 |
| 43 | Update Application B code for modern .NET version | High | 2 |
| 44 | Plan SQL Server 2014/2016 to 2019/2022 migration | High | 2 |
| 45 | Deploy modern infrastructure for Application B | Critical | 3 |
| 46 | Execute database migration for Application B | Critical | 3 |
| 47 | Deploy and verify Application B on modern stack | Critical | 3 |
| 48 | Create Application B migration documentation | High | 3 |

### Epic: Testing & Validation
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 49 | Execute and document infrastructure tests (Terratest, Checkov) | High | 3 |
| 50 | Execute and document configuration tests (Molecule, InSpec) | High | 3 |
| 51 | Execute and document functional tests | High | 3 |
| 52 | Execute and document performance tests | Medium | 3 |
| 53 | Execute and document resiliency tests (AZ failover, DB failover) | High | 3 |
| 54 | Validate data integrity (Week 1 data preserved) | Critical | 3 |

### Epic: Documentation
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 55 | Create architecture documentation with diagrams | High | 2-3 |
| 56 | Create operations runbooks for Application A | High | 3 |
| 57 | Create operations runbooks for Application B | High | 3 |
| 58 | Compile all test reports | High | 3 |
| 59 | Update README with complete project documentation | High | 3 |

### Epic: CI/CD Pipeline
| Issue # | Title | Priority | Week |
|---------|-------|----------|------|
| 60 | Create Jenkins pipeline for Terraform validation | Medium | 2 |
| 61 | Create Jenkins pipeline for Packer image builds | Medium | 2 |
| 62 | Create Jenkins pipeline for Ansible deployment | Medium | 2 |
| 63 | Create Jenkins pipeline for Application A build/deploy | High | 2-3 |
| 64 | Create Jenkins pipeline for Application B build/deploy | High | 2-3 |

---

## Risk Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Legacy app compatibility issues | High | Start deployment early in Week 1; have fallback apps ready |
| Database migration data loss | Critical | Implement backup/restore procedures; validate in staging first |
| Java/JBoss migration breaks app | High | Thorough testing; document all code changes; rollback plan |
| .NET migration compatibility | High | Test in isolated environment first; upgrade dependencies incrementally |
| GCP quotas/limits | Medium | Request quota increases early; use appropriate instance sizes |
| Time constraints | High | Prioritize critical path items; parallelize where possible |

---

## Success Metrics (Aligned with Evaluation Criteria)

### Dimension 1: Onboarding & Context (40%)
- Team productive within 3-5 days
- Gap analysis document completed in Week 1
- Clear understanding of UniCredit context demonstrated

### Dimension 2: Technical Proficiency (60%)
- **Infrastructure as Code (12%)**: Modular Terraform with tests
- **Configuration Management (12%)**: Idempotent Ansible with Molecule tests
- **Architecture & Design (12%)**: Multi-AZ HA, secure, scalable
- **Testing & Quality (12%)**: Comprehensive coverage with reports
- **Migration Capability (12%)**: Both apps migrated, data preserved

### Minimum Scores Required
- Overall: 3.0 / 5.0
- Dimension 1: 2.5 / 5.0
- Dimension 2: 3.0 / 5.0
- Migration: 3.0 / 5.0

---

## Daily Commit Guidelines

Each day should include commits showing:
- Code changes with clear messages
- Documentation updates
- Test additions/updates
- Progress on assigned issues

**Commit Message Format:**
```
[EPIC] Brief description

- Detailed change 1
- Detailed change 2

Refs #<issue-number>
```
