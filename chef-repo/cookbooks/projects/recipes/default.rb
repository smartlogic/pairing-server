
projects = data_bag('projects')

projects.each_with_index do |project, index|
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
    if attributes['public_key']
      keys << attributes['public_key']
    else
      (attributes['public_keys'] || []).each do |key|
        keys << key
      end
    end
  end

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
    variables :keys => keys
  end

  execute "install rvm for #{project}" do
    user project
    group project
    cwd home
    environment ({'HOME' => home})
    command "curl -L get.rvm.io | bash -s stable"
    creates "#{home}/.rvm"
    action :run
  end

  if attributes['ruby_version']
    execute "install ruby #{attributes['ruby_version']} for #{project}" do
      user project
      group project
      cwd home
      environment ({'HOME' => home})
      command "rvm install #{attributes['ruby_version']}"
      not_if "rvm list | grep '#{attributes['ruby_version']}'"
      action :run
    end
  end

  (attributes['rubies'] || []).each do |ruby_version|
    execute "install ruby #{ruby_version} for #{project}" do
      user project
      group project
      cwd home
      environment ({'HOME' => home})
      command "rvm install #{ruby_version}"
      not_if "rvm list | grep '#{ruby_version}'"
      action :run
    end
  end

  directory "/var/run/xvfb" do
    action :create
    mode '0755'
  end

  template "/etc/init.d/xvfb_#{project}" do
    source 'xvfb_init.erb'
    mode  '0755'
    variables :display => "#{99 - index}", :project => project
  end

  execute "restart xvfb #{project}" do
    command "sudo /etc/init.d/xvfb_#{project} restart"
    action :run
  end
end

group 'admin' do
  members projects
  append true
end

