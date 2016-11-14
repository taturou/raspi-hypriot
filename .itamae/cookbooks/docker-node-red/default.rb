directory "/home/pirate/docker" do
  not_if "test -d /home/pirate/docker"
end

git "/home/pirate/docker/node-red" do
  repository "https://github.com/taturou/raspi-hypriot-nodered.git"
  not_if "test -d /home/pirate/docker/node-red"
end

execute "Build Node-RED" do
  command "docker-compose build"
  cwd "/home/pirate/docker/node-red"
end

execute "Start Node-RED" do
  command "docker-compose up -d"
  cwd "/home/pirate/docker/node-red"
end
