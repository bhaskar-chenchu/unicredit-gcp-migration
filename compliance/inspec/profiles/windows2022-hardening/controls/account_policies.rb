# Windows Server 2022 Hardening - Account Policies
# Based on CIS Benchmark for Windows Server 2022

control 'win2022-acct-001' do
  impact 1.0
  title 'Ensure Enforce password history is set to 24 or more'
  desc 'Password history prevents reuse of recent passwords'
  tag 'account-policy'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '1.1.1'

  describe security_policy do
    its('PasswordHistorySize') { should be >= input('password_history_size') }
  end
end

control 'win2022-acct-002' do
  impact 1.0
  title 'Ensure Maximum password age is set to 60 or fewer days'
  desc 'Passwords should expire periodically'
  tag 'account-policy'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '1.1.2'

  describe security_policy do
    its('MaximumPasswordAge') { should be <= input('max_password_age') }
    its('MaximumPasswordAge') { should be > 0 }
  end
end

control 'win2022-acct-003' do
  impact 0.7
  title 'Ensure Minimum password age is set to 1 or more days'
  desc 'Prevents rapid password changes to bypass history'
  tag 'account-policy'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '1.1.3'

  describe security_policy do
    its('MinimumPasswordAge') { should be >= 1 }
  end
end

control 'win2022-acct-004' do
  impact 1.0
  title 'Ensure Minimum password length is set to 14 or more'
  desc 'Longer passwords are more resistant to brute force'
  tag 'account-policy'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '1.1.4'

  describe security_policy do
    its('MinimumPasswordLength') { should be >= input('min_password_length') }
  end
end

control 'win2022-acct-005' do
  impact 1.0
  title 'Ensure Password must meet complexity requirements is Enabled'
  desc 'Complex passwords are more resistant to attack'
  tag 'account-policy'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '1.1.5'

  describe security_policy do
    its('PasswordComplexity') { should eq 1 }
  end
end

control 'win2022-acct-006' do
  impact 1.0
  title 'Ensure Store passwords using reversible encryption is Disabled'
  desc 'Reversible encryption should not be used for passwords'
  tag 'account-policy'
  tag 'password'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '1.1.6'

  describe security_policy do
    its('ClearTextPassword') { should eq 0 }
  end
end

control 'win2022-acct-007' do
  impact 1.0
  title 'Ensure Account lockout duration is set to 15 or more minutes'
  desc 'Account lockout duration prevents rapid retry attacks'
  tag 'account-policy'
  tag 'lockout'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '1.2.1'

  describe security_policy do
    its('LockoutDuration') { should be >= input('lockout_duration') }
  end
end

control 'win2022-acct-008' do
  impact 1.0
  title 'Ensure Account lockout threshold is set to 5 or fewer'
  desc 'Lockout threshold limits password guessing attempts'
  tag 'account-policy'
  tag 'lockout'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '1.2.2'

  describe security_policy do
    its('LockoutBadCount') { should be_between(1, input('lockout_threshold')) }
  end
end

control 'win2022-acct-009' do
  impact 1.0
  title 'Ensure Reset account lockout counter is set to 15 or more minutes'
  desc 'Lockout counter reset prevents sustained brute force'
  tag 'account-policy'
  tag 'lockout'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '1.2.3'

  describe security_policy do
    its('ResetLockoutCount') { should be >= 15 }
  end
end

control 'win2022-acct-010' do
  impact 1.0
  title 'Ensure Guest account status is Disabled'
  desc 'Guest account should be disabled'
  tag 'account-policy'
  tag 'guest'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.1.1'

  describe security_policy do
    its('EnableGuestAccount') { should eq 0 }
  end
end

control 'win2022-acct-011' do
  impact 1.0
  title 'Ensure Administrator account status is Disabled'
  desc 'Built-in Administrator should be renamed or disabled'
  tag 'account-policy'
  tag 'administrator'
  tag 'cis-benchmark'
  ref 'CIS Windows Server 2022 Benchmark', ref: '2.3.1.2'

  describe user('Administrator') do
    it { should be_disabled }
  end
end
