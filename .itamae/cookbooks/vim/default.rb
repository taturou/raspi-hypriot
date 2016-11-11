package 'vim' do
  action :install
end

file '/usr/bin/vi' do
  action :delete
end

link '/usr/bin/vi' do
  to '/usr/bin/vim'
end
