# RHEL 9 Hardening - Filesystem Controls
# Based on CIS Benchmark for RHEL 9

control 'rhel9-fs-001' do
  impact 1.0
  title 'Ensure /tmp is a separate partition'
  desc 'The /tmp directory should be on a separate partition for security isolation'
  tag 'filesystem'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.1.2'

  describe mount('/tmp') do
    it { should be_mounted }
  end
end

control 'rhel9-fs-002' do
  impact 0.7
  title 'Ensure noexec option set on /tmp partition'
  desc 'The noexec mount option prevents execution of binaries from /tmp'
  tag 'filesystem'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.1.3'

  describe mount('/tmp') do
    its('options') { should include 'noexec' }
  end
end

control 'rhel9-fs-003' do
  impact 0.7
  title 'Ensure nosuid option set on /tmp partition'
  desc 'The nosuid mount option prevents setuid bit from taking effect'
  tag 'filesystem'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.1.4'

  describe mount('/tmp') do
    its('options') { should include 'nosuid' }
  end
end

control 'rhel9-fs-004' do
  impact 0.7
  title 'Ensure nodev option set on /tmp partition'
  desc 'The nodev mount option prevents device files from being created'
  tag 'filesystem'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.1.5'

  describe mount('/tmp') do
    its('options') { should include 'nodev' }
  end
end

control 'rhel9-fs-005' do
  impact 1.0
  title 'Ensure /var is a separate partition'
  desc 'The /var directory should be on a separate partition'
  tag 'filesystem'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.1.6'

  describe mount('/var') do
    it { should be_mounted }
  end
end

control 'rhel9-fs-006' do
  impact 1.0
  title 'Ensure /var/log is a separate partition'
  desc 'The /var/log directory should be on a separate partition for log isolation'
  tag 'filesystem'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.1.11'

  describe mount('/var/log') do
    it { should be_mounted }
  end
end

control 'rhel9-fs-007' do
  impact 1.0
  title 'Ensure /var/log/audit is a separate partition'
  desc 'The audit log directory should be on a separate partition'
  tag 'filesystem'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.1.12'

  describe mount('/var/log/audit') do
    it { should be_mounted }
  end
end

control 'rhel9-fs-008' do
  impact 0.7
  title 'Ensure /home is a separate partition'
  desc 'The /home directory should be on a separate partition'
  tag 'filesystem'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.1.13'

  describe mount('/home') do
    it { should be_mounted }
  end
end

control 'rhel9-fs-009' do
  impact 0.5
  title 'Ensure sticky bit is set on all world-writable directories'
  desc 'Setting the sticky bit prevents users from deleting others files'
  tag 'filesystem'
  tag 'permissions'
  ref 'CIS RHEL 9 Benchmark', ref: '1.1.21'

  describe command('df --local -P | awk {\'if (NR!=1) print $6\'} | xargs -I \'{}\' find \'{}\' -xdev -type d -perm -0002 ! -perm -1000 2>/dev/null') do
    its('stdout') { should be_empty }
  end
end

control 'rhel9-fs-010' do
  impact 1.0
  title 'Disable automounting'
  desc 'Automounting of removable media should be disabled'
  tag 'filesystem'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '1.1.22'

  describe service('autofs') do
    it { should_not be_enabled }
    it { should_not be_running }
  end
end
