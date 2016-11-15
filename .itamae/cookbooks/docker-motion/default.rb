directory "/home/pirate/docker" do
  not_if "test -d /home/pirate/docker"
end

git "/home/pirate/docker/motion" do
  repository "https://github.com/taturou/raspi-hypriot-motion.git"
  not_if "test -d /home/pirate/docker/motion"
end

execute "Start motion" do
  command "docker-compose up -d"
  cwd "/home/pirate/docker/motion"
end
