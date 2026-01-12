# Windows Server 2022 Hardening - Audit Policy Controls
# Based on CIS Benchmark for Windows Server 2022

control 'win2022-audit-001' do
  impact 1.0
  title 'Ensure Audit Credential Validation is set to Success and Failure'
  desc 'Credential validation events should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.1.1'

  describe audit_policy do
    its('Credential Validation') { should eq 'Success and Failure' }
  end
end

control 'win2022-audit-002' do
  impact 1.0
  title 'Ensure Audit Application Group Management is set to Success and Failure'
  desc 'Application group management events should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.2.1'

  describe audit_policy do
    its('Application Group Management') { should eq 'Success and Failure' }
  end
end

control 'win2022-audit-003' do
  impact 1.0
  title 'Ensure Audit Security Group Management is set to include Success'
  desc 'Security group management events should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.2.5'

  describe audit_policy do
    its('Security Group Management') { should match(/Success/) }
  end
end

control 'win2022-audit-004' do
  impact 1.0
  title 'Ensure Audit User Account Management is set to Success and Failure'
  desc 'User account management events should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.2.6'

  describe audit_policy do
    its('User Account Management') { should eq 'Success and Failure' }
  end
end

control 'win2022-audit-005' do
  impact 1.0
  title 'Ensure Audit PNP Activity is set to include Success'
  desc 'Plug and Play activity should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.3.1'

  describe audit_policy do
    its('Plug and Play Events') { should match(/Success/) }
  end
end

control 'win2022-audit-006' do
  impact 1.0
  title 'Ensure Audit Process Creation is set to include Success'
  desc 'Process creation events should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.3.2'

  describe audit_policy do
    its('Process Creation') { should match(/Success/) }
  end
end

control 'win2022-audit-007' do
  impact 1.0
  title 'Ensure Audit Account Lockout is set to include Failure'
  desc 'Account lockout events should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.5.1'

  describe audit_policy do
    its('Account Lockout') { should match(/Failure/) }
  end
end

control 'win2022-audit-008' do
  impact 1.0
  title 'Ensure Audit Logoff is set to include Success'
  desc 'Logoff events should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.5.3'

  describe audit_policy do
    its('Logoff') { should match(/Success/) }
  end
end

control 'win2022-audit-009' do
  impact 1.0
  title 'Ensure Audit Logon is set to Success and Failure'
  desc 'Logon events should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.5.4'

  describe audit_policy do
    its('Logon') { should eq 'Success and Failure' }
  end
end

control 'win2022-audit-010' do
  impact 1.0
  title 'Ensure Audit Special Logon is set to include Success'
  desc 'Special logon events should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.5.6'

  describe audit_policy do
    its('Special Logon') { should match(/Success/) }
  end
end

control 'win2022-audit-011' do
  impact 1.0
  title 'Ensure Audit Audit Policy Change is set to include Success'
  desc 'Audit policy changes should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.7.1'

  describe audit_policy do
    its('Audit Policy Change') { should match(/Success/) }
  end
end

control 'win2022-audit-012' do
  impact 1.0
  title 'Ensure Audit Authentication Policy Change is set to include Success'
  desc 'Authentication policy changes should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.7.2'

  describe audit_policy do
    its('Authentication Policy Change') { should match(/Success/) }
  end
end

control 'win2022-audit-013' do
  impact 1.0
  title 'Ensure Audit Sensitive Privilege Use is set to Success and Failure'
  desc 'Sensitive privilege use should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.8.1'

  describe audit_policy do
    its('Sensitive Privilege Use') { should eq 'Success and Failure' }
  end
end

control 'win2022-audit-014' do
  impact 1.0
  title 'Ensure Audit Security State Change is set to include Success'
  desc 'Security state changes should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.9.1'

  describe audit_policy do
    its('Security State Change') { should match(/Success/) }
  end
end

control 'win2022-audit-015' do
  impact 1.0
  title 'Ensure Audit Security System Extension is set to include Success'
  desc 'Security system extension events should be audited'
  tag 'audit'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '17.9.2'

  describe audit_policy do
    its('Security System Extension') { should match(/Success/) }
  end
end
