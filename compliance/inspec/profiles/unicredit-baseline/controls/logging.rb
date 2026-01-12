# UniCredit Baseline - Logging Controls

control 'logging-001' do
  impact 1.0
  title 'Audit logging must be enabled'
  desc 'System audit logging must be enabled for security monitoring'
  tag 'logging'
  tag 'audit'

  only_if { input('enable_logging_controls') }

  if os.linux?
    describe service('auditd') do
      it { should be_enabled }
      it { should be_running }
    end
  elsif os.windows?
    describe audit_policy do
      its('Logon/Logoff') { should_not eq 'No Auditing' }
      its('Account Logon') { should_not eq 'No Auditing' }
    end
  end
end

control 'logging-002' do
  impact 0.7
  title 'Log files must have appropriate permissions'
  desc 'Log files should have restricted permissions to prevent tampering'
  tag 'logging'
  tag 'permissions'

  only_if { os.linux? }

  describe file('/var/log/messages') do
    it { should exist }
    its('mode') { should cmp '0640' }
  end

  describe file('/var/log/secure') do
    it { should exist }
    its('mode') { should cmp '0600' }
  end
end

control 'logging-003' do
  impact 0.7
  title 'Log rotation must be configured'
  desc 'Log rotation should be configured to manage disk space'
  tag 'logging'
  tag 'rotation'

  only_if { os.linux? }

  describe file('/etc/logrotate.conf') do
    it { should exist }
    its('content') { should match /rotate\s+\d+/ }
  end
end

control 'logging-004' do
  impact 1.0
  title 'Failed login attempts must be logged'
  desc 'Failed authentication attempts should be logged for security monitoring'
  tag 'logging'
  tag 'authentication'

  if os.linux?
    describe file('/etc/pam.d/system-auth') do
      its('content') { should match /pam_tally2|pam_faillock/ }
    end
  elsif os.windows?
    describe audit_policy do
      its('Logon/Logoff') { should include 'Failure' }
    end
  end
end

control 'logging-005' do
  impact 0.7
  title 'Privileged command execution must be logged'
  desc 'Execution of privileged commands should be logged'
  tag 'logging'
  tag 'audit'

  only_if { os.linux? }

  describe auditd_rules do
    its('lines') { should include(/-a always,exit -F arch=b64 -S execve -F euid=0/) }
  end
end

control 'logging-006' do
  impact 1.0
  title 'Security events must be forwarded'
  desc 'Security-relevant events should be forwarded to central logging'
  tag 'logging'
  tag 'siem'

  only_if { os.linux? && input('enable_logging_controls') }

  # Check for remote logging configuration
  describe file('/etc/rsyslog.conf') do
    its('content') { should match /@@.*\..*/ } # Remote syslog server
  end
end
