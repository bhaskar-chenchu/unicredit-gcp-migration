# RHEL 9 Hardening - SELinux Controls
# Based on CIS Benchmark for RHEL 9

control 'rhel9-selinux-001' do
  impact 1.0
  title 'Ensure SELinux is installed'
  desc 'SELinux provides mandatory access control security'
  tag 'selinux'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.6.1.1'

  describe package('libselinux') do
    it { should be_installed }
  end
end

control 'rhel9-selinux-002' do
  impact 1.0
  title 'Ensure SELinux is not disabled in bootloader configuration'
  desc 'SELinux must not be disabled via bootloader'
  tag 'selinux'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.6.1.2'

  describe file('/etc/default/grub') do
    its('content') { should_not match(/selinux=0/) }
    its('content') { should_not match(/enforcing=0/) }
  end

  describe command('grubby --info=ALL') do
    its('stdout') { should_not match(/selinux=0/) }
    its('stdout') { should_not match(/enforcing=0/) }
  end
end

control 'rhel9-selinux-003' do
  impact 1.0
  title 'Ensure SELinux policy is configured'
  desc 'SELinux policy must be set to targeted or mls'
  tag 'selinux'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.6.1.3'

  describe file('/etc/selinux/config') do
    its('content') { should match(/^SELINUXTYPE=(targeted|mls)/) }
  end
end

control 'rhel9-selinux-004' do
  impact 1.0
  title 'Ensure SELinux mode is enforcing'
  desc 'SELinux must be in enforcing mode'
  tag 'selinux'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.6.1.4'

  describe file('/etc/selinux/config') do
    its('content') { should match(/^SELINUX=enforcing/) }
  end

  describe command('getenforce') do
    its('stdout') { should match(/Enforcing/) }
  end
end

control 'rhel9-selinux-005' do
  impact 0.7
  title 'Ensure no unconfined services exist'
  desc 'All services should run in SELinux confined domains'
  tag 'selinux'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.6.1.5'

  describe command('ps -eZ | grep unconfined_service_t') do
    its('stdout') { should be_empty }
  end
end

control 'rhel9-selinux-006' do
  impact 1.0
  title 'Ensure SETroubleshoot is not installed'
  desc 'SETroubleshoot should not be installed on production systems'
  tag 'selinux'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.6.1.6'

  describe package('setroubleshoot') do
    it { should_not be_installed }
  end
end

control 'rhel9-selinux-007' do
  impact 0.7
  title 'Ensure MCS Translation Service is not installed'
  desc 'MCS Translation Service is not needed on production systems'
  tag 'selinux'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.6.1.7'

  describe package('mcstrans') do
    it { should_not be_installed }
  end
end
