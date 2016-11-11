directory "/home/pirate/docker" do
  not_if "test -d /home/pirate/docker"
end

git "/home/pirate/docker/dockerui" do
  repository "https://github.com/taturou/raspi-hypriot-dockerui.git"
  not_if "test -d /home/pirate/docker/dockerui"
end

execute "Start DockerUI" do
  command "docker-compose up -d"
  cwd "/home/pirate/docker/dockerui"
end
