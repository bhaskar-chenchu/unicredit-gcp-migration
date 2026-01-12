# RHEL 9 Hardening - Authentication Controls
# Based on CIS Benchmark for RHEL 9

control 'rhel9-auth-001' do
  impact 1.0
  title 'Ensure password creation requirements are configured'
  desc 'Strong password policies reduce risk of compromise'
  tag 'authentication'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.4.1'

  describe file('/etc/security/pwquality.conf') do
    its('content') { should match(/minlen\s*=\s*14/) }
    its('content') { should match(/dcredit\s*=\s*-1/) }
    its('content') { should match(/ucredit\s*=\s*-1/) }
    its('content') { should match(/ocredit\s*=\s*-1/) }
    its('content') { should match(/lcredit\s*=\s*-1/) }
  end
end

control 'rhel9-auth-002' do
  impact 1.0
  title 'Ensure lockout for failed password attempts is configured'
  desc 'Account lockout protects against brute force attacks'
  tag 'authentication'
  tag 'lockout'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.4.2'

  describe file('/etc/security/faillock.conf') do
    its('content') { should match(/deny\s*=\s*[1-5]/) }
    its('content') { should match(/unlock_time\s*=\s*(900|[1-9][0-9]{3,})/) }
  end
end

control 'rhel9-auth-003' do
  impact 0.7
  title 'Ensure password reuse is limited'
  desc 'Password history prevents reuse of recent passwords'
  tag 'authentication'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.4.3'

  describe file('/etc/pam.d/system-auth') do
    its('content') { should match(/pam_pwhistory\.so.*remember=([5-9]|[1-9][0-9]+)/) }
  end
end

control 'rhel9-auth-004' do
  impact 0.7
  title 'Ensure password hashing algorithm is SHA-512'
  desc 'SHA-512 provides strong password hashing'
  tag 'authentication'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.4.4'

  describe file('/etc/login.defs') do
    its('content') { should match(/^ENCRYPT_METHOD\s+SHA512/) }
  end
end

control 'rhel9-auth-005' do
  impact 0.7
  title 'Ensure password expiration is 365 days or less'
  desc 'Passwords should expire periodically'
  tag 'authentication'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.5.1.1'

  describe file('/etc/login.defs') do
    its('content') { should match(/^PASS_MAX_DAYS\s+([1-9]|[1-8][0-9]|9[0-9]|[12][0-9]{2}|3[0-5][0-9]|36[0-5])/) }
  end
end

control 'rhel9-auth-006' do
  impact 0.5
  title 'Ensure minimum days between password changes is 7 or more'
  desc 'Prevents rapid password changes to bypass history'
  tag 'authentication'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.5.1.2'

  describe file('/etc/login.defs') do
    its('content') { should match(/^PASS_MIN_DAYS\s+[7-9]|[1-9][0-9]+/) }
  end
end

control 'rhel9-auth-007' do
  impact 0.5
  title 'Ensure password expiration warning is 7 days or more'
  desc 'Users should be warned before password expiration'
  tag 'authentication'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.5.1.3'

  describe file('/etc/login.defs') do
    its('content') { should match(/^PASS_WARN_AGE\s+[7-9]|[1-9][0-9]+/) }
  end
end

control 'rhel9-auth-008' do
  impact 1.0
  title 'Ensure inactive password lock is 30 days or less'
  desc 'Inactive accounts should be disabled'
  tag 'authentication'
  tag 'account'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.5.1.4'

  describe file('/etc/default/useradd') do
    its('content') { should match(/^INACTIVE=(30|[1-2][0-9]|[1-9])/) }
  end
end

control 'rhel9-auth-009' do
  impact 1.0
  title 'Ensure default group for root account is GID 0'
  desc 'Root account should have GID 0'
  tag 'authentication'
  tag 'root'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.5.3'

  describe user('root') do
    its('gid') { should eq 0 }
  end
end

control 'rhel9-auth-010' do
  impact 0.7
  title 'Ensure default user umask is 027 or more restrictive'
  desc 'Default file permissions should be restrictive'
  tag 'authentication'
  tag 'permissions'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.5.4'

  describe file('/etc/bashrc') do
    its('content') { should match(/umask\s+0[2-7]7/) }
  end

  describe file('/etc/profile') do
    its('content') { should match(/umask\s+0[2-7]7/) }
  end
end

control 'rhel9-auth-011' do
  impact 1.0
  title 'Ensure root login is restricted to system console'
  desc 'Root login should only be allowed from secure terminals'
  tag 'authentication'
  tag 'root'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.5.5'

  describe file('/etc/securetty') do
    it { should exist }
  end
end

control 'rhel9-auth-012' do
  impact 1.0
  title 'Ensure access to su command is restricted'
  desc 'The su command should be restricted to authorized users'
  tag 'authentication'
  tag 'su'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.6'

  describe file('/etc/pam.d/su') do
    its('content') { should match(/pam_wheel\.so.*use_uid/) }
  end

  describe group('wheel') do
    it { should exist }
  end
end
