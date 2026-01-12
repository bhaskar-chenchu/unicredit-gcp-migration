# UniCredit Baseline - Common Controls
# These controls apply to all systems

control 'baseline-001' do
  impact 1.0
  title 'System time must be synchronized'
  desc 'Ensure system time is synchronized with NTP servers for accurate logging and security'
  tag 'baseline'
  tag 'ntp'

  if os.linux?
    describe service('chronyd') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  elsif os.windows?
    describe service('W32Time') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
end

control 'baseline-002' do
  impact 0.7
  title 'System hostname must be properly configured'
  desc 'Ensure system has a valid hostname for identification and logging'
  tag 'baseline'
  tag 'hostname'

  describe command('hostname') do
    its('stdout') { should_not be_empty }
    its('stdout') { should_not match /localhost/ }
  end
end

control 'baseline-003' do
  impact 1.0
  title 'Logging service must be running'
  desc 'Ensure system logging service is active for audit and security purposes'
  tag 'baseline'
  tag 'logging'

  only_if { input('enable_logging_controls') }

  if os.linux?
    describe service('rsyslog') do
      it { should be_enabled }
      it { should be_running }
    end
  elsif os.windows?
    describe service('EventLog') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end

control 'baseline-004' do
  impact 0.7
  title 'System must have required disk space'
  desc 'Ensure adequate disk space is available for system operation'
  tag 'baseline'
  tag 'disk'

  if os.linux?
    describe filesystem('/') do
      its('percent_free') { should be >= 10 }
    end
  elsif os.windows?
    describe command('Get-PSDrive C | Select-Object -ExpandProperty Free') do
      its('stdout.to_i') { should be > 1073741824 } # 1GB in bytes
    end
  end
end

control 'baseline-005' do
  impact 1.0
  title 'System must restrict root/administrator login'
  desc 'Direct root or administrator login should be restricted'
  tag 'baseline'
  tag 'authentication'

  if os.linux?
    describe sshd_config do
      its('PermitRootLogin') { should match(/no|prohibit-password/) }
    end
  elsif os.windows?
    describe security_policy do
      its('EnableGuestAccount') { should eq 0 }
    end
  end
end
