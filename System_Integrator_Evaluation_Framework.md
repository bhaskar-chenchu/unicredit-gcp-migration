# System Integrator Evaluation Framework
## Large-Scale Cloud Migration to GCP

**Project Duration:** 3 Weeks  
**Organization:** UniCredit  
**Repository:** UniCredit Bitbucket (daily commits required)  
**Author:** Granata Andrea (UniCredit)  
**Date:** 19 December, 2025  
**Version:** 2.0 (Migration Enhanced)

---

## Executive Summary

This document defines the evaluation criteria for selecting a system integrator to support a large-scale cloud migration to Google Cloud Platform (GCP). The evaluation consists of two primary assessment areas executed over a 3-week period, designed to test both the vendor's ability to understand UniCredit's context and their technical proficiency in modern cloud-native practices, **with particular emphasis on migration and upgrade capabilities**.

Given the compressed timeline, vendors must demonstrate exceptional organizational agility, technical depth, and the ability to prioritize effectively. All activities must be reflected in daily commits to UniCredit's Bitbucket repository, demonstrating transparency and progress.

**KEY ENHANCEMENT:** Version 2.0 introduces a critical migration requirement: vendors must demonstrate their ability to migrate applications from legacy technology stacks to modern versions. Applications A and B must first be deployed on legacy stacks (RHEL 7, JBoss 7, Java 8 for Application A; older Windows Server and .NET for Application B), verified as functional by UniCredit, then migrated to modern versions (RHEL 9, WildFly latest, Java 17/21 for Application A; current Windows Server and .NET for Application B). This migration capability represents **20% of the technical proficiency evaluation**.

---

## Evaluation Area 1: Onboarding & As-Is Assessment

### Objective
The vendor must rapidly onboard their team and perform a comprehensive assessment of UniCredit's current GCP environment, identifying gaps and improvement opportunities that could impact migration velocity.

### Scope of Assessment

#### 1.1 GCP Landing Zone Analysis
- **Current architecture review** - Multi-project structure, organization policies, folder hierarchy
- **Network topology** - VPC design, subnet allocation, firewall rules, interconnectivity
- **Identity and access management** - IAM policies, service accounts, workload identity configuration
- **Security controls** - Security Command Center usage, Cloud Armor, KMS, Secret Manager
- **Compliance posture** - Regulatory requirements, audit logging, data residency
- **Resource organization** - Naming conventions, tagging strategy, resource hierarchy

#### 1.2 DevOps & Cloud Operations Assessment
- **CI/CD pipelines** - Jenkins setup, pipeline patterns, deployment strategies
- **Infrastructure as Code** - Current Terraform usage, state management, module structure
- **Configuration management** - Ansible playbooks, role organization, inventory management
- **Image management** - Packer usage, base image standards, update mechanisms
- **Testing frameworks** - Current testing practices for infrastructure and configuration
- **Monitoring and observability** - Cloud Monitoring, logging, alerting, dashboards

#### 1.3 Team & Process Evaluation
- **Team structure** - Roles, responsibilities, skill distribution
- **Way of working and ITSM processes** - Agile and project management practices, change management, incident response, security processes
- **Application teams** - Roles of application owners and experts, organizational structure by domains
- **Tooling ecosystem** - Development tools, collaboration platforms, documentation
- **Knowledge management** - Documentation quality, runbooks, architectural decision records

### Deliverable Requirements

**Gap Analysis Document** (expected within Week 1)

The document must include:

1. **Executive Summary** - High-level findings and critical gaps
2. **Current State Overview** - Documented as-is architecture and practices
3. **Gap Identification** - Categorized by severity (Critical/High/Medium/Low)
   - Landing zone gaps affecting security, scalability, or compliance
   - DevOps tooling gaps impacting automation or deployment velocity
   - Process gaps creating bottlenecks or risks
4. **Impact Assessment** - How each gap affects migration speed and success
5. **Remediation Recommendations** - Prioritized improvements with effort estimates
6. **Migration Velocity Analysis** - Realistic assessment of achievable migration pace

### Success Criteria
- **Speed of onboarding** - Team fully productive within 3-5 business days
- **Depth of understanding** - Demonstrates grasp of UniCredit's specific context and constraints
- **Quality of analysis** - Identifies non-obvious gaps that could cause issues
- **Actionable recommendations** - Clear, prioritized, and implementable suggestions
- **Communication effectiveness** - Clear articulation of findings to stakeholders

### Priority Considerations (3-Week Timeline)
- Focus on **critical gaps** that would block migration or create security risks
- Defer deep-dive analysis of areas that are already well-functioning
- Emphasize **quick wins** that can be implemented during the proof-of-concept phase

In case the SI would not be able to perform the onboarding of the full team and do their indipendent assessment based on documentation available and read-only access to live environemnts UCG will make his teams available in 2 dedicated 3-hours sessions of Q&A.

---

## Evaluation Area 2: Technical Proof-of-Concept with Migration Demonstration

### Objective
Configure a new GCP landing zone (outside the UniCredit ecosystem) and deploy two reference applications demonstrating a complete migration journey from legacy to modern technology stacks. Each application must first be deployed on legacy infrastructure, verified by UniCredit as functional, then migrated to modern infrastructure using infrastructure-as-code, configuration management, and automated testing. Where applicable, incorporate lessons learned from Week 1 to align configuration choices and controls.

**CRITICAL MIGRATION REQUIREMENT:** Both applications must demonstrate the vendor's ability to perform real-world technology stack migrations - the core capability needed for UniCredit's modernization initiative. The migration process, automation quality, and final results represent a significant portion of the evaluation.

---

### 2.1 GCP Landing Zone Configuration

#### Infrastructure Requirements
All infrastructure must be configured using **Terraform**:

- **Project structure** - Separate projects for dev/staging/production environments
- **Networking** - VPC with multi-AZ subnet design, Cloud NAT, firewall rules
- **Security** - IAM roles and policies, service accounts with least privilege
- **Monitoring baseline** - Cloud Monitoring, Cloud Logging, alerting policies
- **Compliance controls** - Organization policies reflecting identified requirements
- **Landing zone corrections** - Implement improvements identified in Area 1

#### Infrastructure Testing
- **Terratest** - Unit tests for Terraform modules
- **Checkov** - Policy-as-code scanning for security and compliance
- **terraform validate/plan** - Syntax and configuration validation

---

### 2.2 Application A: Linux/Java Application - Legacy to Modern Migration

#### Migration Journey Overview

Application A must demonstrate a complete migration from legacy Java stack to modern versions, simulating real-world enterprise application modernization scenarios that UniCredit faces.

**Phase 1: Legacy Deployment (Pre-Migration)**
- Deploy application on RHEL 7 with JBoss 7.x and Java 8
- Provide UniCredit with access for functional verification
- UniCredit will test application and create test data records

**Phase 2: Modern Migration (Post-Migration)**
- Migrate to RHEL 9, WildFly 30+, and Java 17/21
- Migrate all data and configurations
- Provide UniCredit with access for functional verification
- UniCredit will verify application works and test data is preserved

---

#### Legacy Stack Specifications (Phase 1)

**Operating System:**
- RHEL 7.x (or CentOS 7.x)
- Alternative: Ubuntu 18.04 LTS

**Application Server:**
- JBoss EAP 7.x (7.0, 7.1, 7.2, or 7.3)
- Alternative: JBoss AS 7.x or WildFly 10.x - 14.x

**Java Runtime:**
- OpenJDK 8 or Oracle JDK 8

**Database:**
- PostgreSQL 9.6 or 10.x

**Deployment:**
- GCP Compute Engine VMs (manual or basic setup acceptable for legacy)
- Cloud SQL for PostgreSQL/MySQL
- Basic load balancer configuration
- Multi-availability zone (minimum 2 AZs)

**Note:** For the legacy environment, full IaC and automation are NOT required. The focus is on getting a working application that UniCredit can verify. Manual VM setup or basic scripts are acceptable as long as the application is functional and accessible for testing.

---

#### Modern Stack Specifications (Phase 2)

**Operating System:**
- RHEL 9.x (or Rocky Linux 9.x / AlmaLinux 9.x)
- Alternative: Ubuntu 22.04 LTS or 24.04 LTS

**Application Server:**
- WildFly 30.x or later (current stable release)
- Alternative: JBoss EAP 8.x

**Java Runtime:**
- OpenJDK 17 LTS or OpenJDK 21 LTS

**Database:**
- PostgreSQL 15.x or 16.x


**Deployment:**
- Compute Engine instance groups (regional, multi-AZ)
- Cloud SQL for PostgreSQL/MySQL (HA configuration with automatic failover)
- Load balancer (HTTP(S) with health checks)
- Firewall rules and network configuration
- IAM service accounts for compute instances

---

#### Application Requirements

The vendor must select or build an application that:
- Runs on JBoss/WildFly with Java 8
- Uses a relational database (PostgreSQL or MySQL)
- Implements typical enterprise patterns (JPA/Hibernate, REST APIs, etc.)
- Allows data creation (CRUD operations)
- Is sufficiently complex to demonstrate real migration challenges

**Suggested Applications:**
- Ticket Monster
- Petclinic
- Kitchensink
- Any JBoss quickstart application with database persistence

**Or build a simple application with:**
- JPA/Hibernate for database operations
- RESTful web services (JAX-RS)
- Simple web UI for data entry
- CRUD operations that UniCredit can test

---

#### Implementation Requirements for Modern Stack

**Image Build (Packer)**
- Base RHEL 9 image with OpenJDK 17/21 and WildFly 30+ installed
- CIS Level 1 hardening applied
- Security updates and patches applied
- Image stored in Compute Engine custom images

**Configuration Management (Ansible)**
- WildFly configuration (datasources, deployment, tuning)
- PostgreSQL client configuration
- Application deployment automation
- Service configuration and startup

**Infrastructure (Terraform)**
- Compute Engine instance groups (regional, multi-AZ)
- Cloud SQL for PostgreSQL (HA configuration with automatic failover)
- Load balancer (HTTP(S) with health checks)
- Firewall rules and network configuration
- IAM service accounts for compute instances

**CI/CD Pipeline (Jenkins)**
- Automated build and test pipeline
- Image build triggers
- Deployment automation to target environment
- Rollback capabilities

**Testing**
- **Molecule** - Ansible role testing
- **InSpec** - Compliance and configuration validation
- **Functional tests** - Application health checks, endpoint testing
- **Performance tests** - Load testing, response time validation
- **Resiliency tests** - AZ failure simulation, database failover validation
- **Migration validation** - Pre/post migration functional equivalence testing

---

#### Migration Process for Application A

**Assessment & Planning**
- Application dependency analysis
- Compatibility assessment (Java 8 → 17/21, JBoss 7 → WildFly 30+, PostgreSQL 9.6/10 → 15/16)
- Risk identification (deprecated APIs, breaking changes)
- Migration strategy definition
- Rollback plan

**Code Updates**
- Update Java version compatibility
- Address deprecated API usage
- Update dependency versions (libraries, frameworks)
- Modify configuration for new WildFly version
- Update database driver versions

**Database Migration**
- Database schema compatibility verification
- Implement database upgrade scripts (PostgreSQL 9.6/10 → 15/16 or MySQL 5.6/5.7 → 8.0)
- Data migration with integrity validation
- Verify test data created by UniCredit is preserved

**Infrastructure Preparation**
- Build Packer images for RHEL 9
- Configure WildFly 30+ via Ansible
- Provision modern database version
- Set up load balancers and networking

**Cutover & Validation**
- Data migration execution
- Application deployment to modern stack
- Smoke testing
- Provide access to UniCredit for verification

---

### 2.3 Application B: Windows/.NET Application - Legacy to Modern Migration

#### Migration Journey Overview

Application B must demonstrate a complete migration from legacy Windows/.NET stack to modern versions.

**Phase 1: Legacy Deployment (Pre-Migration)**
- Deploy application on older Windows Server with older .NET Framework and IIS
- Provide UniCredit with access for functional verification
- UniCredit will test application and create test data records

**Phase 2: Modern Migration (Post-Migration)**
- Migrate to current Windows Server with current .NET and IIS
- Migrate all data and configurations
- Provide UniCredit with access for functional verification
- UniCredit will verify application works and test data is preserved

---

#### Legacy Stack Specifications (Phase 1)

**Operating System:**
- Windows Server 2012 R2 or Windows Server 2016

**Runtime:**
- .NET Framework 4.5 or 4.6

**Web Server:**
- IIS 8.5 or IIS 10

**Database:**
- Microsoft SQL Server 2014 or 2016
- Alternative: PostgreSQL 9.6

**Deployment:**
- GCP Compute Engine VMs (manual or basic setup acceptable for legacy)
- Cloud SQL for SQL Server
- Basic load balancer configuration
- Multi-availability zone (minimum 2 AZs)

**Note:** For the legacy environment, full IaC and automation are NOT required. Manual VM setup or basic scripts are acceptable as long as the application is functional and accessible for testing.

---

#### Modern Stack Specifications (Phase 2)

**Operating System:**
- Windows Server 2022 or Windows Server 2019

**Runtime:**
- .NET Framework 4.8 or .NET 6/7/8

**Web Server:**
- IIS 10 (latest patches)

**Database:**
- Microsoft SQL Server 2019 or 2022
- Alternative: PostgreSQL 15/16 or MySQL 8.0

**Deployment:**
- Compute Engine instance groups (regional, multi-AZ)
- Cloud SQL for SQL Server (HA configuration with automatic failover)
- Load balancer (HTTP(S) with health checks)
- Firewall rules and network configuration
- IAM service accounts for compute instances

---

#### Application Requirements

The vendor must select or build an application that:
- Runs on IIS with .NET Framework 4.5/4.6
- Uses a relational database (SQL Server, PostgreSQL, or MySQL)
- Implements typical ASP.NET patterns
- Allows data creation (CRUD operations)
- Is sufficiently complex to demonstrate real migration challenges

**Or build a simple ASP.NET application with:**
- Entity Framework for database operations
- ASP.NET Web API or ASP.NET MVC
- Simple web UI for data entry
- CRUD operations that UniCredit can test

---

#### Implementation Requirements for Modern Stack

**Image Build (Packer)**
- Base Windows Server 2022/2019 image with .NET and IIS
- CIS Level 1 hardening applied
- Security updates and patches
- Image stored in Compute Engine custom images

**Configuration Management (Ansible)**
- IIS configuration (application pools, sites, bindings)
- SQL Server client configuration
- Application deployment
- Windows service configuration

**Infrastructure (Terraform)**
- Compute Engine instance groups (regional, multi-AZ)
- Cloud SQL for SQL Server (HA configuration with automatic failover)
- Load balancer (HTTP(S) with health checks)
- Firewall rules and network configuration
- IAM service accounts for compute instances

**CI/CD Pipeline (Jenkins)**
- Automated build and test pipeline
- Image build triggers
- Deployment automation
- Rollback capabilities

**Testing**
- **Molecule** - Ansible role testing (with Windows support)
- **InSpec** - Compliance and configuration validation
- **Functional tests** - Application health checks, endpoint testing
- **Performance tests** - Load testing, response time validation
- **Resiliency tests** - AZ failure simulation, database failover validation
- **Migration validation** - Pre/post migration functional equivalence testing

---

#### Migration Process for Application B

**Assessment & Planning**
- Application dependency analysis
- Compatibility assessment (.NET 4.5/4.6 → 4.8 or .NET 6+, Windows Server 2012/2016 → 2022, SQL Server 2014/2016 → 2019/2022)
- Risk identification (deprecated APIs, breaking changes)
- Migration strategy definition
- Rollback plan

**Code Updates**
- Update .NET version compatibility
- Address deprecated API usage
- Update dependency versions (NuGet packages)
- Update configuration for newer IIS/Windows Server
- Update database driver versions

**Database Migration**
- Database schema compatibility verification
- Implement database upgrade scripts (SQL Server 2014/2016 → 2019/2022)
- Data migration with integrity validation
- Verify test data created by UniCredit is preserved

**Infrastructure Preparation**
- Build Packer images for Windows Server 2022/2019
- Configure IIS via Ansible
- Provision modern database version
- Set up load balancers and networking

**Cutover & Validation**
- Data migration execution
- Application deployment to modern stack
- Smoke testing
- Provide access to UniCredit for verification

---

### 2.4 Repository Structure & Version Control

**Git Repository (UniCredit Bitbucket)**

Required repository structure:
```
├── terraform/
│   ├── modules/
│   ├── environments/
│   └── tests/
├── packer/
│   ├── linux/
│   │   └── rhel9/          # Modern stack images
│   └── windows/
│       └── win2022/        # Modern stack images
├── ansible/
│   ├── roles/
│   ├── playbooks/
│   │   ├── linux-modern/   # WildFly 30+ configuration
│   │   └── windows-modern/ # Windows Server 2022 + .NET
│   └── inventory/
├── applications/
│   ├── app-a/
│   │   ├── legacy-src/     # Java 8 + JBoss 7 source
│   │   ├── modern-src/     # Java 17/21 + WildFly 30+ source
│   │   └── migration/      # Migration scripts & docs
│   └── app-b/
│       ├── legacy-src/     # .NET 4.5/4.6 source
│       ├── modern-src/     # .NET 4.8 or .NET 6+ source
│       └── migration/      # Migration scripts & docs
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
│       ├── app-a-migration-guide.md
│       └── app-b-migration-guide.md
└── README.md
```

**Commit Requirements:**
- Minimum one commit per day (demonstrating progress)
- Clear, descriptive commit messages
- Branching strategy (feature branches, pull requests)
- Code review evidence (if team has multiple members)

---

### 2.5 Testing & Validation Reports

**Required Test Reports:**

1. **Infrastructure Tests**
   - Terratest results
   - Checkov policy scan results
   - Terraform plan validation

2. **Configuration Tests**
   - Molecule test results (both Linux and Windows)
   - InSpec compliance scan results
   - CIS Level 1 benchmark validation

3. **Functional Tests**
   - Application deployment verification
   - Endpoint testing results
   - Database connectivity validation

4. **Performance Tests**
   - Load test results (requests per second, response times)
   - Resource utilization metrics
   - Database performance under load

5. **Resiliency Tests**
   - AZ failure scenario results
   - Database failover testing
   - Recovery time objectives (RTO) measurements
   - Recovery point objectives (RPO) validation

6. **Migration Validation Tests**
   - **Application A:**
     - Pre-migration functionality tests (legacy stack)
     - Post-migration functionality tests (modern stack)
     - Data integrity verification
     - Performance comparison
   - **Application B:**
     - Pre-migration functionality tests (legacy stack)
     - Post-migration functionality tests (modern stack)
     - Data integrity verification
     - Performance comparison

All test reports must be committed to the repository in the `docs/test-reports/` directory.

---

### 2.6 Migration Documentation Requirements

For each application (A and B), the vendor must provide:

**1. Migration Strategy Document**
   - Assessment findings and risk analysis
   - Technology stack compatibility analysis
   - Migration approach and timeline
   - Technical architecture diagrams (before/after)
   - Rollback procedures
   - Lessons learned and recommendations

**2. Code Change Documentation**
   - Detailed list of code changes required
   - Diff/comparison between legacy and modern versions
   - Deprecated API replacements
   - Configuration changes

**3. Database Migration Documentation**
   - Schema changes required
   - Data migration approach
   - Validation procedures
   - Rollback procedures

**4. Runbooks**
   - Step-by-step migration execution guide
   - Troubleshooting guide
   - Operations and maintenance guide for modern stack

---

### Priority Considerations (3-Week Timeline)

**Week 1: Foundation & Legacy Deployment**
- Complete Area 1 assessment and gap analysis
- GCP landing zone setup
- Deploy Application A on legacy stack (RHEL 7, JBoss 7, Java 8)
- Deploy Application B on legacy stack (Windows Server 2012/2016, .NET 4.5/4.6)
- Provide UniCredit with access for pre-migration verification
- Begin migration planning and code analysis

**Week 2: Migration Execution & Modern Infrastructure**
- Build Packer images for modern stacks
- Develop Terraform modules for modern infrastructure
- Update application code for modern versions
- Create Ansible playbooks for configuration
- Begin database migration preparation
- Start Application A migration

**Week 3: Migration Completion & Validation**
- Complete Application A migration
- Complete Application B migration
- Execute all testing phases
- Implement CIS Level 1 hardening
- Provide UniCredit with access for post-migration verification
- Finalize all documentation and test reports

**Prioritization Strategy:**
- Get legacy applications functional quickly (Week 1)
- Focus on migration automation and repeatability
- Prioritize data integrity validation
- Document migration challenges and solutions as they occur
- Application A migration should be completed before Application B

---

## Evaluation Framework

### Dimension 1: Ability to Quickly Onboard & Understand UniCredit Context

This dimension assesses the vendor's organizational agility, cultural fit, and ability to rapidly become productive within UniCredit's environment.

**Weight in Overall Score: 40%**

#### Scoring Criteria (1-5 scale)

| Score | Onboarding Speed | Context Understanding | Stakeholder Engagement |
|-------|------------------|----------------------|------------------------|
| **5 - Exceptional** | Team fully productive within 2-3 days. Immediately identifies key contacts and processes. | Demonstrates deep understanding of UniCredit's business drivers, constraints, and culture. Asks insightful questions. | Proactively engages stakeholders. Builds trust quickly. Adapts communication style appropriately. |
| **4 - Strong** | Team productive within 3-5 days. Navigates systems and processes with minimal guidance. | Shows good grasp of UniCredit's environment. Identifies most relevant concerns and priorities. | Effective stakeholder communication. Responsive to feedback. Good collaboration. |
| **3 - Adequate** | Team productive within 5-7 days. Requires some guidance on processes and systems. | Basic understanding of UniCredit's environment. Misses some context-specific considerations. | Communicates adequately. Responds to direction. Functional collaboration. |
| **2 - Below Expectations** | Team requires 7-10 days to become productive. Struggles with processes and access. | Limited understanding of UniCredit's specific needs. Generic approach with little customization. | Reactive communication. Misses stakeholder expectations. Limited engagement. |
| **1 - Inadequate** | Team unable to become productive within timeline. Significant barriers to onboarding. | Fails to grasp UniCredit's context. Inappropriate or generic recommendations. | Poor communication. Misaligned expectations. Difficult collaboration. |

#### Evaluation Indicators

**Onboarding Speed (Weight: 35%)**
- Time to first meaningful contribution
- Self-sufficiency in navigating UniCredit systems (Bitbucket, Jenkins, GCP console)
- Ability to work independently vs. requiring hand-holding
- Speed of access provisioning resolution
- Adaptation to UniCredit's processes and tools

**Context Understanding (Weight: 40%)**
- Quality of questions asked during kickoff
- Relevance of gap analysis findings to UniCredit's specific situation
- Recognition of UniCredit-specific constraints (regulatory, operational, cultural)
- Customization of approach vs. off-the-shelf methodology
- Understanding of banking industry requirements and compliance needs

**Stakeholder Engagement (Weight: 25%)**
- Communication clarity and frequency
- Responsiveness to questions and concerns
- Ability to explain technical concepts to non-technical stakeholders
- Proactive identification and escalation of blockers
- Building rapport with UniCredit team members

#### Evidence Sources
- Gap analysis document quality and relevance
- Daily standup participation and contributions
- Bitbucket commit messages and code comments
- Stakeholder feedback (informal pulse checks)
- Response time to queries and requests
- Documentation clarity and completeness

---

### Dimension 2: Technical Proficiency

This dimension assesses the vendor's technical capabilities across infrastructure-as-code, configuration management, cloud architecture, DevOps practices, **and migration/upgrade capabilities**.

**Weight in Overall Score: 60%**

#### Scoring Criteria (1-5 scale)

| Score | Infrastructure as Code | Configuration & Automation | Architecture & Design | Testing & Quality | **Migration Capability** |
|-------|------------------------|---------------------------|----------------------|-------------------|------------------------|
| **5 - Exceptional** | Terraform code is modular, reusable, and follows best practices. Excellent state management. | Ansible roles are idempotent, well-structured, and maintainable. Excellent Windows support. | Landing zone design is secure, scalable, and operationally excellent. Multi-AZ HA implemented perfectly. | Comprehensive test coverage. All testing tools used effectively. Excellent test reports. | **Both applications successfully migrated. Flawless execution. Zero data loss. Application functionality preserved perfectly. Excellent automation and documentation.** |
| **4 - Strong** | Good Terraform structure with modules. Minor improvements possible. Clean code. | Ansible code is functional and mostly well-organized. Good practices evident. | Solid architecture with good security and availability. Minor optimization opportunities. | Good test coverage across most areas. Clear test reports. | **Both applications migrated successfully with minor issues resolved. Good automation. Data integrity maintained. Clear documentation.** |
| **3 - Adequate** | Terraform code works but has structural issues. Some copy-paste or monolithic code. | Ansible works but may have redundancy or maintainability concerns. | Architecture meets requirements but has some design compromises. | Basic testing implemented. Some gaps in coverage. Test reports present but basic. | **Both applications migrated but with manual intervention required. Basic automation. Some data validation gaps. Documentation adequate.** |
| **2 - Below Expectations** | Terraform code is poorly structured or error-prone. State management issues. | Ansible code is brittle or not idempotent. Poor organization. | Architecture has significant gaps or design flaws. HA not fully implemented. | Minimal testing. Many gaps in coverage. Test reports incomplete. | **Only one application migrated or migrations have significant issues. Limited automation. Data integrity concerns. Poor documentation.** |
| **1 - Inadequate** | Terraform code doesn't work or violates fundamental best practices. | Ansible fails to work reliably. Major issues with Windows or Linux implementation. | Architecture is fundamentally flawed or insecure. | Little to no testing. No meaningful test reports. | **Migrations failed or not attempted. No automation. Data loss or corruption. Missing documentation.** |

#### Evaluation Indicators

**Infrastructure as Code - Terraform (Weight: 20%)**
- Module design and reusability
- State management approach (remote state, locking)
- Resource organization and naming conventions
- Use of variables, outputs, and data sources
- Terratest implementation quality
- Checkov policy compliance
- Code organization and documentation

**Configuration Management - Ansible & Packer (Weight: 20%)**
- Ansible role structure and reusability
- Idempotency of playbooks
- Variable management and templating
- Molecule test coverage and quality
- Packer template organization
- CIS Level 1 hardening implementation
- Support for both Linux and Windows platforms

**Cloud Architecture & Design (Weight: 20%)**
- GCP landing zone design (security, networking, IAM)
- Multi-AZ high availability implementation
- Database HA and failover configuration
- Load balancer design and health checks
- Security controls (firewall rules, service accounts, least privilege)
- Monitoring and logging setup
- Scalability and performance considerations

**Testing & Quality Assurance (Weight: 20%)**
- Infrastructure testing (Terratest, Checkov)
- Configuration testing (Molecule, InSpec)
- Functional testing comprehensiveness
- Performance test design and execution
- Resiliency testing (failover, recovery)
- Migration validation testing
- Test report quality and completeness
- CI/CD pipeline with integrated testing

**Migration & Upgrade Capability (Weight: 20%)**
- **Migration planning and risk assessment**
- **Technical execution quality (OS, middleware, database, runtime upgrades)**
- **Code modernization approach and quality**
- **Database migration and data integrity validation**
- **Application functionality preservation**
- **Performance comparison and optimization**
- **Migration automation (where applicable)**
- **Documentation and runbooks quality**
- **Problem-solving during migration challenges**

#### Evidence Sources
- Bitbucket repository code review
- Terraform plan outputs
- Test execution results and reports
- Deployed infrastructure validation
- Application functionality and performance
- Resiliency test outcomes
- **Pre-migration application testing by UniCredit (legacy stacks)**
- **Post-migration application testing by UniCredit (modern stacks)**
- **Data integrity verification by UniCredit**
- **Migration documentation and runbooks**
- Documentation quality (README, architecture diagrams)

---

## Scoring & Evaluation Process

### Overall Scoring Model

**Total Score Calculation:**
```
Dimension 1 (Onboarding & Context): 40% of total
Dimension 2 (Technical Proficiency): 60% of total

Within Dimension 2:
- Infrastructure as Code: 20% × 0.60 = 12% of total
- Configuration & Automation: 20% × 0.60 = 12% of total
- Architecture & Design: 20% × 0.60 = 12% of total
- Testing & Quality: 20% × 0.60 = 12% of total
- Migration Capability: 20% × 0.60 = 12% of total

Total Score = (Dimension 1 Score × 0.40) + (Dimension 2 Score × 0.60)
```

**Scoring Scale:**
- 4.5 - 5.0: Exceptional - Exceeds expectations significantly
- 3.5 - 4.4: Strong - Meets expectations with some areas of excellence
- 2.5 - 3.4: Adequate - Meets minimum requirements
- 1.5 - 2.4: Below Expectations - Significant gaps present
- 1.0 - 1.4: Inadequate - Does not meet requirements

### Evaluation Process

**Week 1 Checkpoint (End of Week 1)**
- Evaluate onboarding speed and initial context understanding
- Review gap analysis document
- Assess initial GCP landing zone work
- **Verify Application A is functional on legacy stack (UniCredit testing)**
- **Verify Application B is functional on legacy stack (UniCredit testing)**
- Provide feedback and course correction if needed

**Week 2 Checkpoint (End of Week 2)**
- Review migration planning documentation
- Assess Terraform modules and Ansible roles for modern stacks
- Evaluate migration progress (Application A should be in progress)
- Check repository commit frequency and quality
- Review preliminary test results

**Final Evaluation (End of Week 3)**
- Complete assessment of both dimensions
- Review all deliverables and test reports
- **Verify Application A migration success (UniCredit testing on modern stack)**
- **Verify Application B migration success (UniCredit testing on modern stack)**
- **Verify data created in Week 1 is preserved and accessible**
- Evaluate migration documentation and automation quality
- Calculate final scores
- Make vendor selection decision

### Evaluation Team

Proposed evaluators:

* **Cloud Architects** – Assess landing zone design and GCP best practices.
* **DevOps Lead** – Evaluate IaC, configuration management, and CI/CD.
* **Security Engineer** – Review security controls and compliance.
* **Application Team Lead (Java)** – Validate Application A deployment and migration.
* **Application Team Lead (Windows/.NET)** – Validate Application B deployment and migration.

For each role, we should assign **one evaluator from Google** and **one from UCG**.


---

## Success Criteria & Decision Framework

### Minimum Acceptance Criteria

To be considered for selection, vendors must achieve:
- **Overall Score:** Minimum 3.0 / 5.0
- **Dimension 1 Score:** Minimum 2.5 / 5.0
- **Dimension 2 Score:** Minimum 3.0 / 5.0
- **Migration Capability Score:** Minimum 3.0 / 5.0 (mandatory)
- **Deliverables:** All required deliverables completed
- **Applications:** Both applications deployed on legacy stacks AND successfully migrated to modern stacks
- **Data Integrity:** Test data created by UniCredit in Week 1 must be accessible and valid after migration
- **Testing:** All required test types executed with reports

### Decision Factors Beyond Scoring

While scores provide quantitative comparison, also consider:
- **Cultural fit** - Team dynamics with UniCredit staff
- **Communication style** - Clarity, transparency, proactiveness
- **Problem-solving approach** - How blockers and challenges were handled during migration
- **Scalability** - Can this team scale to support large migration program?
- **Knowledge transfer** - Willingness to share knowledge and build internal capability
- **Migration experience** - Demonstrated ability to handle complex technology upgrades

### Recommendation

Select the vendor that:
1. Meets all minimum acceptance criteria (including migration score)
2. Achieves the highest overall score
3. Demonstrates the best balance of technical proficiency and organizational fit
4. Shows the greatest potential to scale and support the full migration program
5. **Demonstrates strong migration capabilities through both Application A and B**

If scores are close (within 0.3 points), prioritize:
- **Migration capability** - Critical for UniCredit's modernization goals
- **Dimension 1 (Onboarding & Context)** - Stronger predictor of long-term success

---

## Appendix A: Evaluation Templates

### Gap Analysis Document Template

Expected structure for the Area 1 deliverable:

1. **Executive Summary** (1-2 pages)
2. **Assessment Methodology** (1 page)
3. **Current State Overview** (3-5 pages)
   - GCP Landing Zone
   - DevOps Tooling
   - Team & Processes
4. **Gap Analysis** (5-10 pages)
   - Critical Gaps
   - High Priority Gaps
   - Medium Priority Gaps
   - Low Priority Gaps
5. **Remediation Roadmap** (3-5 pages)
6. **Migration Velocity Impact** (2-3 pages)
7. **Recommendations** (2-3 pages)

---

### Migration Documentation Template

Expected structure for each application's migration documentation:

**1. Executive Summary** (1 page)
   - Migration objectives
   - Key challenges encountered
   - Overall approach taken
   - Results summary

**2. Pre-Migration Assessment** (2-3 pages)
   - Legacy environment analysis
   - Application dependencies
   - Technology stack compatibility assessment
   - Risk identification

**3. Migration Architecture** (2-3 pages)
   - Before/after architecture diagrams
   - Infrastructure changes
   - Network topology changes
   - Security control updates

**4. Technical Implementation** (3-5 pages)
   - Code changes required (with examples)
   - Configuration modifications
   - Database migration approach
   - Migration scripts and automation

**5. Testing & Validation** (2-3 pages)
   - Pre-migration test results
   - Post-migration test results
   - Data integrity verification
   - Performance comparison

**6. Lessons Learned** (1-2 pages)
   - Challenges encountered
   - Solutions implemented
   - Recommendations for future migrations

---

### Test Report Template

Required content for each test report:

1. **Test Objective**
2. **Test Environment** (legacy or modern)
3. **Test Methodology**
4. **Test Execution Summary**
5. **Results** (pass/fail, metrics)
6. **Issues Identified**
7. **Recommendations**
8. **Appendices** (raw data, logs, screenshots)

---

### Repository README Template

Minimum content for repository README:

1. **Project Overview**
2. **Repository Structure**
3. **Prerequisites**
4. **Quick Start Guide**
5. **Deployment Instructions**
   - Application A - Legacy stack (Week 1)
   - Application A - Modern stack (Weeks 2-3)
   - Application B - Legacy stack (Week 1)
   - Application B - Modern stack (Weeks 2-3)
6. **Migration Execution Guide**
   - Application A migration steps
   - Application B migration steps
7. **Testing Instructions**
8. **Architecture Documentation Links**
9. **Troubleshooting Guide**
10. **Contact Information**

---

## Appendix B: Migration Evaluation Rubric

### Detailed Scoring Criteria for Migration Capability (20% of Dimension 2)

| Criterion | Weight | Score 5 | Score 4 | Score 3 | Score 2 | Score 1 |
|-----------|--------|---------|---------|---------|---------|---------|
| **Planning & Assessment** | 15% | Comprehensive analysis with detailed risk mitigation for both applications. Proactive identification of all compatibility issues. | Thorough analysis covering most risks for both apps. Good understanding of challenges. | Basic analysis completed for both apps. Some risks identified. | Limited analysis. Missing key risks. Analysis incomplete for one app. | No meaningful planning or assessment. |
| **Technical Execution** | 25% | Flawless upgrade of both applications. All components work perfectly on modern stacks. Zero issues. | Successful upgrade of both apps with minor issues quickly resolved. Applications fully functional. | Both apps upgraded but required multiple attempts or manual fixes. Functional end state. | Only one app successfully migrated, or significant issues remain. | Failed migrations or not attempted. |
| **Data Migration** | 20% | 100% data integrity verified for both applications. UniCredit test data preserved perfectly. Zero data loss. | Data successfully migrated for both apps with minor validation gaps. No data loss. Test data accessible. | Data migrated but manual verification required. Some inconsistencies found and fixed. | Data migration incomplete or with integrity issues. Test data partially lost. | Data loss or corruption occurred. |
| **Code Modernization** | 20% | Excellent code updates. Modern best practices applied. Clean, maintainable code. Well-documented changes. | Good code updates. Modern versions working well. Clear documentation of changes. | Code updated to work on modern stack. Some technical debt remains. Basic documentation. | Poor code quality. Many workarounds. Incomplete documentation. | Code changes inadequate or missing. |
| **Documentation** | 10% | Comprehensive, clear, actionable docs for both migrations. Excellent runbooks. Ready for production use. | Good documentation covering most aspects of both migrations. Usable runbooks. | Basic documentation present for both apps. Missing some details. | Limited documentation. Hard to follow or incomplete. | Poor or missing documentation. |
| **Problem Solving** | 10% | Exceptional handling of challenges across both migrations. Creative solutions. Proactive issue resolution. | Good problem-solving for both apps. Issues addressed effectively. | Adequate problem-solving. Some delays in resolution. | Poor problem-solving. Many unresolved issues. | Unable to handle challenges effectively. |

### UniCredit Verification Checklist

**Pre-Migration Verification (Week 1) - Both Applications:**
- [ ] Application accessible via provided URL/IP
- [ ] Login/authentication works (if applicable)
- [ ] Can create new records in database
- [ ] Can view existing records
- [ ] Application performs expected business functions
- [ ] Technology versions confirmed (RHEL 7, JBoss 7, Java 8 for App A; Windows Server 2012/2016, .NET 4.5/4.6 for App B)

**Post-Migration Verification (Week 3) - Both Applications:**
- [ ] Application accessible via provided URL/IP
- [ ] Login/authentication works (if applicable)
- [ ] Can create new records in database
- [ ] Can view records created in Week 1 (data preserved)
- [ ] Application performs expected business functions
- [ ] Technology versions confirmed (RHEL 9, WildFly 30+, Java 17/21 for App A; Windows Server 2022/2019, .NET 4.8 or .NET 6+ for App B)
- [ ] Performance equal to or better than legacy
- [ ] No functional regressions identified

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 19 Dec 2025 | UniCredit | Initial evaluation framework |
| 2.0 | 21 Dec 2025 | UniCredit | Enhanced Applications A and B to demonstrate migration from legacy to modern stacks. Application A: RHEL 7/JBoss 7/Java 8 → RHEL 9/WildFly 30+/Java 17-21. Application B: Windows Server 2012-2016/.NET 4.5-4.6 → Windows Server 2022-2019/.NET 4.8 or .NET 6+. Migration capability now represents 20% of technical proficiency scoring. Removed Application C. Clarified that legacy deployment can be manual/basic (no full IaC required). |

---

**Note:** This evaluation framework is designed to be objective, comprehensive, and fair. Vendors should be provided with this document in advance to ensure transparency and enable them to demonstrate their capabilities fully within the 3-week timeline. The migration capability assessment through Applications A and B is mandatory and represents a significant portion of the technical evaluation, reflecting UniCredit's real-world need to modernize legacy applications at scale. The focus is on demonstrating the vendor's ability to successfully migrate working applications from end-of-life technology stacks to modern versions while preserving functionality and data integrity.