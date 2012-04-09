package 'zsh' do
  action :install
end

package 'tmux' do
  action :install
end

package 'xvfb' do
  action :install
end

package 'libqt4-dev' do
  action :install
end

package 'git' do
  action :install
end

projects = data_bag('projects')

projects.each do |project|
  attributes = data_bag_item('projects', project)
  (attributes['packages'] || []).each do |pkg|
    package pkg do
      action :install
    end
  end
end

