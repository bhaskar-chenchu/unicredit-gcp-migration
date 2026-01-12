# RHEL 9 Hardening - Services Controls
# Based on CIS Benchmark for RHEL 9

control 'rhel9-svc-001' do
  impact 0.7
  title 'Ensure xinetd is not installed'
  desc 'Legacy xinetd service should not be installed'
  tag 'services'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '2.1.1'

  describe package('xinetd') do
    it { should_not be_installed }
  end
end

control 'rhel9-svc-002' do
  impact 0.7
  title 'Ensure unnecessary services are disabled'
  desc 'Unused services should be disabled to reduce attack surface'
  tag 'services'
  tag 'cis-benchmark'

  input('unnecessary_services').each do |svc|
    describe service(svc) do
      it { should_not be_enabled }
      it { should_not be_running }
    end
  end
end

control 'rhel9-svc-003' do
  impact 1.0
  title 'Ensure time synchronization is in use'
  desc 'System time must be synchronized'
  tag 'services'
  tag 'ntp'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '2.2.1'

  describe.one do
    describe service('chronyd') do
      it { should be_enabled }
      it { should be_running }
    end
    describe service('ntpd') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end

control 'rhel9-svc-004' do
  impact 0.7
  title 'Ensure Avahi Server is not installed'
  desc 'Avahi is a multicast DNS service that should not be installed'
  tag 'services'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '2.2.3'

  describe package('avahi') do
    it { should_not be_installed }
  end
end

control 'rhel9-svc-005' do
  impact 1.0
  title 'Ensure CUPS is not installed'
  desc 'Printing services should not be installed on servers'
  tag 'services'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '2.2.4'

  describe package('cups') do
    it { should_not be_installed }
  end
end

control 'rhel9-svc-006' do
  impact 1.0
  title 'Ensure DHCP Server is not installed'
  desc 'DHCP server should not be installed unless required'
  tag 'services'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '2.2.5'

  describe package('dhcp-server') do
    it { should_not be_installed }
  end
end

control 'rhel9-svc-007' do
  impact 1.0
  title 'Ensure LDAP server is not installed'
  desc 'LDAP server should not be installed unless required'
  tag 'services'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '2.2.6'

  describe package('openldap-servers') do
    it { should_not be_installed }
  end
end

control 'rhel9-svc-008' do
  impact 1.0
  title 'Ensure NFS is not installed'
  desc 'NFS should not be installed unless required'
  tag 'services'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '2.2.7'

  describe package('nfs-utils') do
    it { should_not be_installed }
  end
end

control 'rhel9-svc-009' do
  impact 1.0
  title 'Ensure FTP Server is not installed'
  desc 'FTP server should not be installed'
  tag 'services'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '2.2.9'

  describe package('vsftpd') do
    it { should_not be_installed }
  end
end

control 'rhel9-svc-010' do
  impact 1.0
  title 'Ensure HTTP server is not installed'
  desc 'Web server should be installed only on dedicated web servers'
  tag 'services'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '2.2.10'

  # Skip if this is a web server
  only_if('Not a dedicated web server') do
    !file('/opt/wildfly').exist?
  end

  describe package('httpd') do
    it { should_not be_installed }
  end

  describe package('nginx') do
    it { should_not be_installed }
  end
end

control 'rhel9-svc-011' do
  impact 1.0
  title 'Ensure rsync service is not installed'
  desc 'rsync service should not be installed unless required'
  tag 'services'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '2.2.19'

  describe package('rsync-daemon') do
    it { should_not be_installed }
  end
end

control 'rhel9-svc-012' do
  impact 1.0
  title 'Ensure mail transfer agent is configured for local-only mode'
  desc 'MTA should only listen on localhost'
  tag 'services'
  tag 'cis-benchmark'
  ref 'CIS RHEL 9 Benchmark', ref: '2.2.20'

  describe port(25) do
    its('addresses') { should_not include '0.0.0.0' }
    its('addresses') { should_not include '::' }
  end
end
