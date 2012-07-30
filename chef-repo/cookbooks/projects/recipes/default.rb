
projects = data_bag('projects')

projects.each_with_index do |project, index|
  attributes = data_bag_item('projects', project)
  shell = attributes['shell'] || 'zsh'

  home = "/home/#{project}"
  user(project) do
    home      home
    shell     "/bin/#{shell}"
    supports  :manage_home => true
  end

  group "sudo" do
    members project
    append true
  end

  keys = []
  (attributes['members'] || []).each do |member|
    member_attributes = data_bag_item('people', member)
    if member_attributes['public_key']
      keys << member_attributes['public_key']
    else
      (member_attributes['public_keys'] || []).each do |key|
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

  gem_package "rake" do
    action :install
  end

  if shell == 'bash'
    execute "clear .bashrc for #{project}" do
      user project
      group project
      cwd home
      environment ({'HOME' => home})
      command %{rm .bashrc}
      action :run
    end
  end

  if attributes['dotfiles'] && attributes['dotfiles']['repo'] && attributes['dotfiles']['init']
    execute "install dotfiles for #{project}" do
      user project
      group project
      cwd home
      environment ({'HOME' => home})
      command "git clone #{attributes['dotfiles']['repo']} #{attributes['dotfiles']['install_loc']} && cd #{attributes['dotfiles']['install_loc']} && ./#{attributes['dotfiles']['init']}"
      creates "#{home}/#{attributes['dotfiles']['install_loc']}"
      action :run
    end
  else
    log("Not installing any dotfiles, dotfiles:{repo, init} not found in #{project} data bag") { level :warn }
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

  if shell == 'bash'
    execute "load rvm into .bashrc for #{project}" do
      user project
      group project
      cwd home
      environment ({'HOME' => home})
      command %{echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bashrc}
      not_if %{grep RVM .bashrc}
      action :run
    end

    template "#{home}/.bash_profile" do
      owner project
      group project
      source "bash_profile.erb"
      mode '0644'
    end
  end

  if attributes['ruby_version']
    execute "install ruby #{attributes['ruby_version']} for #{project}" do
      user project
      group project
      cwd home
      environment ({'HOME' => home})
      command "~/.rvm/bin/rvm install #{attributes['ruby_version']}"
      not_if %{~/.rvm/bin/rvm list | grep '#{attributes['ruby_version']}'}
      action :run
    end
  end

  (attributes['rubies'] || []).each do |ruby_version|
    execute "install ruby #{ruby_version} for #{project}" do
      user project
      group project
      cwd home
      environment ({'HOME' => home})
      command "~/.rvm/bin/rvm install #{ruby_version}"
      not_if %{~/.rvm/bin/rvm list | grep '#{ruby_version}'}
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

  execute "register xvfb for run levels" do
    command "sudo update-rc.d xvfb_#{project} defaults"
    action :run
  end

  execute "restart xvfb #{project}" do
    command "sudo /etc/init.d/xvfb_#{project} restart"
    action :run
  end

  template "#{home}/.zshrc.local" do
    owner project
    group project
    source "zshrc_local.erb"
    mode '0644'
    variables :display => "#{99 - index}"
  end

  template "#{home}/.bashrc.local" do
    owner project
    group project
    source "zshrc_local.erb"
    mode '0644'
    variables :display => "#{99 - index}"
  end
end

group 'admin' do
  members projects
  append true
end

