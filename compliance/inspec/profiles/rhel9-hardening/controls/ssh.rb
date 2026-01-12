# RHEL 9 Hardening - SSH Controls
# Based on CIS Benchmark for RHEL 9

control 'rhel9-ssh-001' do
  impact 1.0
  title 'Ensure SSH Protocol is set to 2'
  desc 'SSH Protocol 2 is more secure than Protocol 1'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.4'

  describe sshd_config do
    its('Protocol') { should cmp 2 }
  end
end

control 'rhel9-ssh-002' do
  impact 1.0
  title 'Ensure SSH root login is disabled'
  desc 'Disabling root login over SSH prevents brute force attacks'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.10'

  describe sshd_config do
    its('PermitRootLogin') { should match(/no|prohibit-password/) }
  end
end

control 'rhel9-ssh-003' do
  impact 0.7
  title 'Ensure SSH MaxAuthTries is set to 4 or less'
  desc 'Limiting authentication attempts reduces brute force attack effectiveness'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.7'

  describe sshd_config do
    its('MaxAuthTries') { should cmp <= input('ssh_max_auth_tries') }
  end
end

control 'rhel9-ssh-004' do
  impact 0.7
  title 'Ensure SSH IgnoreRhosts is enabled'
  desc 'IgnoreRhosts prevents legacy authentication methods'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.8'

  describe sshd_config do
    its('IgnoreRhosts') { should eq 'yes' }
  end
end

control 'rhel9-ssh-005' do
  impact 1.0
  title 'Ensure SSH HostbasedAuthentication is disabled'
  desc 'Host-based authentication should be disabled'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.9'

  describe sshd_config do
    its('HostbasedAuthentication') { should eq 'no' }
  end
end

control 'rhel9-ssh-006' do
  impact 1.0
  title 'Ensure SSH PermitEmptyPasswords is disabled'
  desc 'Empty passwords should never be permitted'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.11'

  describe sshd_config do
    its('PermitEmptyPasswords') { should eq 'no' }
  end
end

control 'rhel9-ssh-007' do
  impact 0.7
  title 'Ensure SSH PermitUserEnvironment is disabled'
  desc 'Users should not be able to set environment options'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.12'

  describe sshd_config do
    its('PermitUserEnvironment') { should eq 'no' }
  end
end

control 'rhel9-ssh-008' do
  impact 0.7
  title 'Ensure only strong ciphers are used'
  desc 'Only approved strong ciphers should be used for SSH'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.13'

  weak_ciphers = [
    '3des-cbc',
    'aes128-cbc',
    'aes192-cbc',
    'aes256-cbc',
    'arcfour',
    'arcfour128',
    'arcfour256',
    'blowfish-cbc',
    'cast128-cbc',
    'rijndael-cbc@lysator.liu.se'
  ]

  describe sshd_config do
    its('Ciphers') { should_not be_nil }
  end

  if sshd_config.Ciphers
    weak_ciphers.each do |cipher|
      describe sshd_config do
        its('Ciphers') { should_not include cipher }
      end
    end
  end
end

control 'rhel9-ssh-009' do
  impact 0.7
  title 'Ensure only strong MAC algorithms are used'
  desc 'Only approved MAC algorithms should be used'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.14'

  weak_macs = [
    'hmac-md5',
    'hmac-md5-96',
    'hmac-ripemd160',
    'hmac-sha1',
    'hmac-sha1-96',
    'umac-64@openssh.com',
    'hmac-md5-etm@openssh.com',
    'hmac-md5-96-etm@openssh.com',
    'hmac-ripemd160-etm@openssh.com',
    'hmac-sha1-etm@openssh.com',
    'hmac-sha1-96-etm@openssh.com',
    'umac-64-etm@openssh.com'
  ]

  if sshd_config.MACs
    weak_macs.each do |mac|
      describe sshd_config do
        its('MACs') { should_not include mac }
      end
    end
  end
end

control 'rhel9-ssh-010' do
  impact 0.5
  title 'Ensure SSH Idle Timeout Interval is configured'
  desc 'SSH sessions should timeout after inactivity'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.16'

  describe sshd_config do
    its('ClientAliveInterval') { should cmp <= 300 }
    its('ClientAliveCountMax') { should cmp <= 3 }
  end
end

control 'rhel9-ssh-011' do
  impact 0.7
  title 'Ensure SSH LoginGraceTime is set to one minute or less'
  desc 'LoginGraceTime should be set to reduce exposure'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.17'

  describe sshd_config do
    its('LoginGraceTime') { should cmp <= 60 }
  end
end

control 'rhel9-ssh-012' do
  impact 1.0
  title 'Ensure SSH access is limited'
  desc 'SSH access should be limited to authorized users/groups'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.18'

  describe.one do
    describe sshd_config do
      its('AllowUsers') { should_not be_nil }
    end
    describe sshd_config do
      its('AllowGroups') { should_not be_nil }
    end
    describe sshd_config do
      its('DenyUsers') { should_not be_nil }
    end
    describe sshd_config do
      its('DenyGroups') { should_not be_nil }
    end
  end
end

control 'rhel9-ssh-013' do
  impact 0.7
  title 'Ensure SSH warning banner is configured'
  desc 'A warning banner should be displayed before login'
  tag 'ssh'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '5.2.19'

  describe sshd_config do
    its('Banner') { should_not be_nil }
    its('Banner') { should_not eq 'none' }
  end
end
