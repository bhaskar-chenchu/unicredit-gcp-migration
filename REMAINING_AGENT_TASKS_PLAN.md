# Remaining Agent-Automatable Tasks Plan

## Overview

This document outlines the implementation plan for remaining tasks that can be fully completed by coding agents without requiring GCP credentials, application source code, or manual intervention.

---

## Phase 1: Infrastructure Testing (Issues #21, #22)

### Issue #21 - Terratest for Terraform Modules

**Objective:** Create Go-based Terratest tests for all Terraform modules

**Deliverables:**
```
tests/
├── terratest/
│   ├── go.mod
│   ├── go.sum
│   ├── network_test.go
│   ├── compute_test.go
│   ├── cloudsql_test.go
│   ├── iam_test.go
│   ├── load_balancer_test.go
│   └── fixtures/
│       ├── network/
│       ├── compute/
│       ├── cloudsql/
│       ├── iam/
│       └── load-balancer/
```

**Test Coverage:**
| Module | Tests |
|--------|-------|
| network | VPC creation, subnet CIDR validation, firewall rules, NAT gateway |
| compute | Instance template, MIG creation, health check configuration |
| cloudsql | Instance creation, HA configuration, private IP, backup settings |
| iam | Service account creation, role bindings, Workload Identity |
| load-balancer | Backend service, URL map, SSL certificate, forwarding rules |

**Implementation Steps:**
1. Initialize Go module with Terratest dependencies
2. Create test fixtures with minimal variable configurations
3. Implement unit tests (validate plan output without apply)
4. Implement integration tests (apply and validate resources)
5. Add helper functions for common assertions
6. Create Makefile for test execution

---

### Issue #22 - Checkov Security Scanning

**Objective:** Integrate Checkov security scanning into CI/CD and create custom policies

**Deliverables:**
```
security/
├── checkov/
│   ├── .checkov.yml                    # Checkov configuration
│   ├── custom-policies/
│   │   ├── gcp/
│   │   │   ├── CKV_GCP_CUSTOM_001.py  # Require private IP for Cloud SQL
│   │   │   ├── CKV_GCP_CUSTOM_002.py  # Require CMEK encryption
│   │   │   ├── CKV_GCP_CUSTOM_003.py  # Require VPC flow logs
│   │   │   └── CKV_GCP_CUSTOM_004.py  # Require uniform bucket-level access
│   │   └── __init__.py
│   ├── suppressions/
│   │   └── .checkov.suppressions.yml  # Known exceptions
│   └── baseline/
│       └── checkov-baseline.json       # Baseline for existing issues
├── reports/
│   └── .gitkeep
└── run-checkov.sh                      # Execution script
```

**Custom Policies for UniCredit:**
1. `CKV_GCP_CUSTOM_001` - Cloud SQL must use private IP only
2. `CKV_GCP_CUSTOM_002` - All storage must use CMEK encryption
3. `CKV_GCP_CUSTOM_003` - VPC flow logs must be enabled
4. `CKV_GCP_CUSTOM_004` - Compute instances must not have public IPs
5. `CKV_GCP_CUSTOM_005` - IAM bindings must not use allUsers/allAuthenticatedUsers

**Implementation Steps:**
1. Create Checkov configuration file
2. Implement custom Python policies
3. Create suppression file for known exceptions
4. Generate baseline from current state
5. Update Jenkins pipeline with Checkov stage
6. Create HTML/JSON report generation

---

## Phase 2: Compliance Testing (Issues #35, #36, #37)

### Issue #35 - InSpec Compliance Profiles

**Objective:** Create InSpec profile structure and shared controls

**Deliverables:**
```
compliance/
├── inspec/
│   ├── profiles/
│   │   ├── unicredit-baseline/
│   │   │   ├── inspec.yml
│   │   │   ├── controls/
│   │   │   │   ├── common.rb
│   │   │   │   ├── network.rb
│   │   │   │   └── logging.rb
│   │   │   └── libraries/
│   │   ├── rhel9-hardening/
│   │   │   ├── inspec.yml
│   │   │   ├── controls/
│   │   │   └── files/
│   │   └── windows2022-hardening/
│   │       ├── inspec.yml
│   │       ├── controls/
│   │       └── files/
│   ├── waivers/
│   │   ├── dev.yml
│   │   ├── staging.yml
│   │   └── prod.yml
│   └── attributes/
│       ├── default.yml
│       └── unicredit.yml
├── run-inspec.sh
└── Gemfile
```

**Profile Hierarchy:**
```
unicredit-baseline (base controls)
    ├── rhel9-hardening (extends baseline)
    └── windows2022-hardening (extends baseline)
```

---

### Issue #36 - InSpec Tests for RHEL 9 Hardening

**Objective:** Implement CIS Benchmark-aligned controls for RHEL 9

**Control Categories:**
| Category | Controls | Priority |
|----------|----------|----------|
| Filesystem | Mount options, permissions, partition layout | High |
| Services | Disabled unnecessary services, required services running | High |
| Network | Firewall rules, kernel parameters, IP forwarding | High |
| Authentication | PAM configuration, password policies, SSH hardening | Critical |
| Logging | Auditd rules, rsyslog configuration, log permissions | High |
| Access Control | SELinux enabled, sudo configuration, user accounts | Critical |

**Sample Controls:**
```ruby
# SSH Hardening
control 'rhel9-ssh-001' do
  impact 1.0
  title 'SSH Protocol Version'
  desc 'Ensure SSH Protocol is set to 2'

  describe sshd_config do
    its('Protocol') { should cmp 2 }
  end
end

# SELinux
control 'rhel9-selinux-001' do
  impact 1.0
  title 'SELinux Enforcing'
  desc 'Ensure SELinux is not disabled in bootloader'

  describe command('getenforce') do
    its('stdout') { should match /Enforcing/ }
  end
end
```

---

### Issue #37 - InSpec Tests for Windows 2022 Hardening

**Objective:** Implement CIS Benchmark-aligned controls for Windows Server 2022

**Control Categories:**
| Category | Controls | Priority |
|----------|----------|----------|
| Account Policies | Password policy, lockout policy, Kerberos | Critical |
| Local Policies | Audit policy, user rights, security options | High |
| Windows Firewall | Domain/Private/Public profiles, rules | High |
| Advanced Audit | Detailed audit policies | Medium |
| Windows Defender | Real-time protection, exclusions | High |
| IIS Hardening | Request filtering, TLS settings, headers | High |

**Sample Controls:**
```ruby
# Password Policy
control 'win2022-password-001' do
  impact 1.0
  title 'Minimum Password Length'
  desc 'Ensure minimum password length is 14 or more'

  describe security_policy do
    its('MinimumPasswordLength') { should be >= 14 }
  end
end

# Windows Firewall
control 'win2022-firewall-001' do
  impact 1.0
  title 'Windows Firewall Enabled'
  desc 'Ensure Windows Firewall is enabled for all profiles'

  describe command('Get-NetFirewallProfile | Select-Object -ExpandProperty Enabled') do
    its('stdout') { should match /True.*True.*True/ }
  end
end
```

---

## Phase 3: Observability (Issues #55, #56, #57, #58)

### Issue #55 - GCP Monitoring Dashboards

**Objective:** Create Cloud Monitoring dashboard definitions

**Deliverables:**
```
monitoring/
├── dashboards/
│   ├── app-a-dashboard.json          # Java/WildFly metrics
│   ├── app-b-dashboard.json          # .NET/IIS metrics
│   ├── infrastructure-dashboard.json  # Compute, network, storage
│   ├── database-dashboard.json        # Cloud SQL metrics
│   └── security-dashboard.json        # Security-related metrics
├── terraform/
│   └── monitoring.tf                  # Dashboard provisioning
└── README.md
```

**Dashboard Widgets:**
| Dashboard | Widgets |
|-----------|---------|
| App A | JVM heap, GC time, request latency, error rate, thread count |
| App B | CLR memory, request queue, CPU/memory, response time |
| Infrastructure | Instance CPU/memory, disk IOPS, network throughput |
| Database | Connections, query latency, replication lag, storage |
| Security | Failed logins, firewall denies, IAM changes |

---

### Issue #56 - Alerting Policies

**Objective:** Create Cloud Monitoring alerting policy definitions

**Deliverables:**
```
monitoring/
├── alerts/
│   ├── compute-alerts.json
│   ├── database-alerts.json
│   ├── application-alerts.json
│   ├── security-alerts.json
│   └── slo-alerts.json
├── notification-channels/
│   └── channels.tf
└── terraform/
    └── alerting.tf
```

**Alert Policies:**
| Category | Alert | Threshold | Severity |
|----------|-------|-----------|----------|
| Compute | High CPU | >85% for 5min | Warning |
| Compute | High Memory | >90% for 5min | Warning |
| Compute | Instance Down | Uptime check fails | Critical |
| Database | High Connections | >80% max | Warning |
| Database | Replication Lag | >30 seconds | Critical |
| Application | Error Rate | >5% for 5min | Critical |
| Application | Latency P99 | >2 seconds | Warning |
| Security | Failed SSH | >10 in 5min | Critical |

---

### Issue #57 - Log-based Metrics

**Objective:** Create custom log-based metrics for application monitoring

**Deliverables:**
```
monitoring/
├── log-metrics/
│   ├── app-a-metrics.tf
│   ├── app-b-metrics.tf
│   ├── security-metrics.tf
│   └── audit-metrics.tf
└── log-sinks/
    └── sinks.tf
```

**Log-based Metrics:**
| Metric | Log Filter | Type |
|--------|------------|------|
| app_a_errors | severity="ERROR" AND resource.type="gce_instance" | Counter |
| app_b_exceptions | "Exception" AND resource.labels.instance_id | Counter |
| auth_failures | "authentication failure" | Counter |
| sql_slow_queries | "slow query" AND duration>1000 | Distribution |

---

### Issue #58 - Uptime Checks

**Objective:** Configure uptime checks for application endpoints

**Deliverables:**
```
monitoring/
├── uptime-checks/
│   ├── app-a-uptime.tf
│   ├── app-b-uptime.tf
│   └── infrastructure-uptime.tf
└── terraform/
    └── uptime.tf
```

**Uptime Check Configuration:**
| Check | Endpoint | Interval | Timeout | Regions |
|-------|----------|----------|---------|---------|
| App A Health | /health | 60s | 10s | 3 |
| App A API | /api/status | 60s | 10s | 3 |
| App B Health | /health | 60s | 10s | 3 |
| App B API | /api/status | 60s | 10s | 3 |
| Load Balancer | / | 60s | 10s | 5 |

---

## Implementation Timeline

```
Phase 1: Infrastructure Testing
├── #21 Terratest ──────────────── [████████░░] ~4 hours
└── #22 Checkov ────────────────── [████████░░] ~3 hours

Phase 2: Compliance Testing
├── #35 InSpec Profiles ────────── [██████░░░░] ~2 hours
├── #36 RHEL 9 Hardening ───────── [████████░░] ~4 hours
└── #37 Windows 2022 Hardening ─── [████████░░] ~4 hours

Phase 3: Observability
├── #55 Dashboards ─────────────── [██████░░░░] ~2 hours
├── #56 Alerting ───────────────── [██████░░░░] ~2 hours
├── #57 Log Metrics ────────────── [████░░░░░░] ~1 hour
└── #58 Uptime Checks ──────────── [████░░░░░░] ~1 hour
```

---

## Execution Order (Recommended)

1. **Checkov (#22)** - Quick win, enhances security posture immediately
2. **Terratest (#21)** - Validates existing Terraform modules
3. **InSpec Profiles (#35)** - Foundation for compliance testing
4. **RHEL 9 Hardening (#36)** - Critical for App A security
5. **Windows 2022 Hardening (#37)** - Critical for App B security
6. **Dashboards (#55)** - Visibility into system health
7. **Alerting (#56)** - Proactive issue detection
8. **Log Metrics (#57)** - Application-level insights
9. **Uptime Checks (#58)** - External availability monitoring

---

## Dependencies

```
None ─────────► #22 Checkov
None ─────────► #21 Terratest
None ─────────► #35 InSpec Profiles
#35 ──────────► #36 RHEL 9 Hardening
#35 ──────────► #37 Windows 2022 Hardening
None ─────────► #55 Dashboards
#55 ──────────► #56 Alerting
#55 ──────────► #57 Log Metrics
None ─────────► #58 Uptime Checks
```

---

## Files to be Created Summary

| Phase | New Files | Lines of Code (Est.) |
|-------|-----------|---------------------|
| Phase 1 | 15 | ~2,000 |
| Phase 2 | 25 | ~3,500 |
| Phase 3 | 20 | ~1,500 |
| **Total** | **60** | **~7,000** |
