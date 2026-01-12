# UniCredit Baseline - Network Controls

control 'network-001' do
  impact 1.0
  title 'Firewall must be enabled'
  desc 'Ensure host-based firewall is enabled to control network traffic'
  tag 'network'
  tag 'firewall'

  only_if { input('enable_network_controls') }

  if os.linux?
    describe service('firewalld') do
      it { should be_enabled }
      it { should be_running }
    end
  elsif os.windows?
    describe command('Get-NetFirewallProfile | Where-Object {$_.Enabled -eq $false}') do
      its('stdout') { should be_empty }
    end
  end
end

control 'network-002' do
  impact 1.0
  title 'IP forwarding must be disabled'
  desc 'IP forwarding should be disabled unless explicitly required'
  tag 'network'
  tag 'kernel'

  only_if { os.linux? }

  describe kernel_parameter('net.ipv4.ip_forward') do
    its('value') { should eq 0 }
  end

  describe kernel_parameter('net.ipv6.conf.all.forwarding') do
    its('value') { should eq 0 }
  end
end

control 'network-003' do
  impact 0.7
  title 'ICMP redirects must be disabled'
  desc 'ICMP redirects should be disabled to prevent potential MITM attacks'
  tag 'network'
  tag 'kernel'

  only_if { os.linux? }

  describe kernel_parameter('net.ipv4.conf.all.accept_redirects') do
    its('value') { should eq 0 }
  end

  describe kernel_parameter('net.ipv4.conf.default.accept_redirects') do
    its('value') { should eq 0 }
  end
end

control 'network-004' do
  impact 0.7
  title 'Source routing must be disabled'
  desc 'Source routing should be disabled to prevent routing manipulation'
  tag 'network'
  tag 'kernel'

  only_if { os.linux? }

  describe kernel_parameter('net.ipv4.conf.all.accept_source_route') do
    its('value') { should eq 0 }
  end

  describe kernel_parameter('net.ipv4.conf.default.accept_source_route') do
    its('value') { should eq 0 }
  end
end

control 'network-005' do
  impact 0.7
  title 'TCP SYN cookies must be enabled'
  desc 'SYN cookies should be enabled to prevent SYN flood attacks'
  tag 'network'
  tag 'kernel'

  only_if { os.linux? }

  describe kernel_parameter('net.ipv4.tcp_syncookies') do
    its('value') { should eq 1 }
  end
end

control 'network-006' do
  impact 1.0
  title 'Only allowed ports should be listening'
  desc 'System should only have expected services listening on network ports'
  tag 'network'
  tag 'ports'

  allowed_ports = input('allowed_ssh_ports') + [80, 443, 8080, 9990]

  if os.linux?
    describe port.where { protocol =~ /tcp/ && address =~ /0.0.0.0|::/ } do
      its('ports') { should be_in allowed_ports }
    end
  end
end
