
projects = data_bag('projects')

projects.each do |project|
  attributes = data_bag_item('projects', project)
  home = "/home/#{project}"
  user(project) do
    home      home
    shell     '/bin/zsh'
    supports  :manage_home => true
  end

  keys = []
  (attributes['members'] || []).each do |member|
    attributes = data_bag_item('people', member)
    keys << attributes['public_key']
  end
  node['project_member_keys'] = keys

  directory "#{home}/.ssh" do
    action :create
    owner  project
    group  project
    mode   '0700'
  end

  template "#{home}/.ssh/authorized_keys" do
    source 'authorized_keys.erb'
    owner project
    group project
    mode  '0600'
  end
end

group 'admin' do
  members projects
  append true
end
