remote_file "/etc/resolv.conf" do
  owner "systemd-resolve"
  group "systemd-resolve"
  source :auto
end

remote_file "/etc/network/interfaces.d/eth0" do
  owner "root"
  group "root"
  source :auto
end

remote_file "/etc/network/interfaces.d/wlan0" do
  owner "root"
  group "root"
  source :auto
end
