execute "Setup to deployed Node.js v7.x" do
  command "curl -sL https://deb.nodesource.com/setup_7.x | sudo bash -"
  cwd "/home/pirate"
  only_if "grep '\/\<node_7\>' /etc/apt/sources.list.d/nodesource.list"
end

package "nodejs" do
  action :install
  not_if "test -f /usr/bin/node"
end
