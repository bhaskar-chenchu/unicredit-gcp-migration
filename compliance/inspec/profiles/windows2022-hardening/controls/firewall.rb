# Windows Server 2022 Hardening - Windows Firewall Controls
# Based on CIS Benchmark for Windows Server 2022

control 'win2022-fw-001' do
  impact 1.0
  title 'Ensure Windows Firewall: Domain: Firewall state is On'
  desc 'Windows Firewall should be enabled for Domain profile'
  tag 'firewall'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '9.1.1'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\DomainProfile') do
    its('EnableFirewall') { should eq 1 }
  end
end

control 'win2022-fw-002' do
  impact 1.0
  title 'Ensure Windows Firewall: Domain: Inbound connections is Block'
  desc 'Inbound connections should be blocked by default'
  tag 'firewall'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '9.1.2'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\DomainProfile') do
    its('DefaultInboundAction') { should eq 1 }
  end
end

control 'win2022-fw-003' do
  impact 0.7
  title 'Ensure Windows Firewall: Domain: Outbound connections is Allow'
  desc 'Outbound connections allowed by default'
  tag 'firewall'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '9.1.3'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\DomainProfile') do
    its('DefaultOutboundAction') { should eq 0 }
  end
end

control 'win2022-fw-004' do
  impact 1.0
  title 'Ensure Windows Firewall: Private: Firewall state is On'
  desc 'Windows Firewall should be enabled for Private profile'
  tag 'firewall'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '9.2.1'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\PrivateProfile') do
    its('EnableFirewall') { should eq 1 }
  end
end

control 'win2022-fw-005' do
  impact 1.0
  title 'Ensure Windows Firewall: Private: Inbound connections is Block'
  desc 'Inbound connections should be blocked for Private profile'
  tag 'firewall'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '9.2.2'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\PrivateProfile') do
    its('DefaultInboundAction') { should eq 1 }
  end
end

control 'win2022-fw-006' do
  impact 1.0
  title 'Ensure Windows Firewall: Public: Firewall state is On'
  desc 'Windows Firewall should be enabled for Public profile'
  tag 'firewall'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '9.3.1'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\PublicProfile') do
    its('EnableFirewall') { should eq 1 }
  end
end

control 'win2022-fw-007' do
  impact 1.0
  title 'Ensure Windows Firewall: Public: Inbound connections is Block'
  desc 'Inbound connections should be blocked for Public profile'
  tag 'firewall'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '9.3.2'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\PublicProfile') do
    its('DefaultInboundAction') { should eq 1 }
  end
end

control 'win2022-fw-008' do
  impact 0.7
  title 'Ensure Windows Firewall logging is enabled'
  desc 'Firewall logging should be enabled for all profiles'
  tag 'firewall'
  tag 'logging'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '9.1.7'

  %w[DomainProfile PrivateProfile PublicProfile].each do |profile|
    describe registry_key("HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\#{profile}\\Logging") do
      its('LogDroppedPackets') { should eq 1 }
      its('LogSuccessfulConnections') { should eq 1 }
    end
  end
end

control 'win2022-fw-009' do
  impact 0.7
  title 'Ensure Windows Firewall log size is adequate'
  desc 'Firewall log files should have adequate size'
  tag 'firewall'
  tag 'logging'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '9.1.8'

  %w[DomainProfile PrivateProfile PublicProfile].each do |profile|
    describe registry_key("HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\#{profile}\\Logging") do
      its('LogFileSize') { should be >= 16384 } # 16 MB
    end
  end
end
