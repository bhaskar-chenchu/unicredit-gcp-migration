# Windows Server 2022 Hardening - Security Options
# Based on CIS Benchmark for Windows Server 2022

control 'win2022-sec-001' do
  impact 1.0
  title 'Ensure Accounts: Limit local account use of blank passwords is Enabled'
  desc 'Blank passwords should be prohibited'
  tag 'security-options'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.1.3'

  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Lsa') do
    its('LimitBlankPasswordUse') { should eq 1 }
  end
end

control 'win2022-sec-002' do
  impact 0.7
  title 'Ensure Interactive logon: Do not display last user name is Enabled'
  desc 'Last username should not be displayed at logon'
  tag 'security-options'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.7.1'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System') do
    its('DontDisplayLastUserName') { should eq 1 }
  end
end

control 'win2022-sec-003' do
  impact 0.7
  title 'Ensure Interactive logon: Machine inactivity limit is set to 900 or fewer'
  desc 'Screen should lock after inactivity'
  tag 'security-options'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.7.3'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System') do
    its('InactivityTimeoutSecs') { should be <= 900 }
    its('InactivityTimeoutSecs') { should be > 0 }
  end
end

control 'win2022-sec-004' do
  impact 1.0
  title 'Ensure Microsoft network client: Digitally sign communications (always) is Enabled'
  desc 'SMB signing should be required'
  tag 'security-options'
  tag 'smb'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.8.1'

  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\LanmanWorkstation\\Parameters') do
    its('RequireSecuritySignature') { should eq 1 }
  end
end

control 'win2022-sec-005' do
  impact 1.0
  title 'Ensure Microsoft network server: Digitally sign communications (always) is Enabled'
  desc 'SMB server signing should be required'
  tag 'security-options'
  tag 'smb'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.9.1'

  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\LanManServer\\Parameters') do
    its('RequireSecuritySignature') { should eq 1 }
  end
end

control 'win2022-sec-006' do
  impact 1.0
  title 'Ensure Network access: Do not allow anonymous enumeration of SAM accounts is Enabled'
  desc 'Anonymous SAM enumeration should be disabled'
  tag 'security-options'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.10.2'

  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Lsa') do
    its('RestrictAnonymousSAM') { should eq 1 }
  end
end

control 'win2022-sec-007' do
  impact 1.0
  title 'Ensure Network access: Do not allow anonymous enumeration of SAM accounts and shares is Enabled'
  desc 'Anonymous enumeration should be fully disabled'
  tag 'security-options'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.10.3'

  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Lsa') do
    its('RestrictAnonymous') { should eq 1 }
  end
end

control 'win2022-sec-008' do
  impact 1.0
  title 'Ensure Network security: LAN Manager authentication level is set correctly'
  desc 'LM authentication should be disabled'
  tag 'security-options'
  tag 'authentication'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.11.7'

  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Lsa') do
    its('LmCompatibilityLevel') { should eq 5 } # Send NTLMv2 response only. Refuse LM & NTLM
  end
end

control 'win2022-sec-009' do
  impact 1.0
  title 'Ensure Network security: Minimum session security for NTLM SSP clients'
  desc 'Require NTLMv2 and 128-bit encryption'
  tag 'security-options'
  tag 'authentication'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.11.9'

  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Lsa\\MSV1_0') do
    its('NTLMMinClientSec') { should eq 537395200 }
  end
end

control 'win2022-sec-010' do
  impact 1.0
  title 'Ensure Network security: Minimum session security for NTLM SSP servers'
  desc 'Require NTLMv2 and 128-bit encryption for servers'
  tag 'security-options'
  tag 'authentication'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.11.10'

  describe registry_key('HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Lsa\\MSV1_0') do
    its('NTLMMinServerSec') { should eq 537395200 }
  end
end

control 'win2022-sec-011' do
  impact 1.0
  title 'Ensure Shutdown: Allow system to be shut down without having to log on is Disabled'
  desc 'System shutdown should require authentication'
  tag 'security-options'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.13.1'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System') do
    its('ShutdownWithoutLogon') { should eq 0 }
  end
end

control 'win2022-sec-012' do
  impact 1.0
  title 'Ensure User Account Control: Admin Approval Mode for Built-in Administrator is Enabled'
  desc 'UAC should apply to built-in Administrator'
  tag 'security-options'
  tag 'uac'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.17.1'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System') do
    its('FilterAdministratorToken') { should eq 1 }
  end
end

control 'win2022-sec-013' do
  impact 1.0
  title 'Ensure User Account Control: Run all administrators in Admin Approval Mode is Enabled'
  desc 'UAC Admin Approval Mode should be enabled'
  tag 'security-options'
  tag 'uac'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.17.6'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System') do
    its('EnableLUA') { should eq 1 }
  end
end
