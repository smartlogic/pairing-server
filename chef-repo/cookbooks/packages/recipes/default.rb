
# Shell stuff
package 'zsh'
package 'tmux'

# Headless testing stuff
if node['platform'] == 'centos'
  package "xorg-x11-server-Xvfb"
  package 'firefox'
  execute "add ATrpms" do
    command %{rpm -i http://dl.atrpms.net/el6-x86_64/atrpms/stable/atrpms-repo-6-5.el6.x86_64.rpm}
    not_if %{yum repolist | grep atrpms}
    action :run
  end
  execute "install qt47 webkit" do
    command %{yum install -y --enablerepo=atrpms-testing qt47-webkit-devel}
    action :run
  end
else
  package 'xvfb'
  package 'firefox'
  package 'libqt4-dev'
end


# Git
package 'git-core'

# Stuff to build stuff
package 'curl'

include_recipe 'build-essential'
if node['platform'] == 'centos'
  %w(readline-devel zlib-devel openssl-devel libxml2-devel libxslt-devel libtool).each do |pkg|
    package pkg
  end
else
  %w(libreadline-dev zlib1g-dev libssl-dev libxml2-dev libxslt1-dev libtool).each do |pkg|
    package pkg
  end
end

package 'vim'

if node['platform'] == 'ubuntu' && node['platform_version'] == "12.04"
  package 'exuberant-ctags'
else
  package 'ctags'
end

package 'ack-grep'

# typical project dependencies
package 'pdftk'
package 'xpdf'
package 'libgif4'
package 'redis-server'
package 'memcached'

package 'libssl0.9.8' # for prince to be happy

if node['platform'] == 'ubuntu'
  if node['platform_version'] == "12.04"
    remote_file '/tmp/prince_8.1-1_ubuntu12.04_amd64.deb' do
      source 'http://www.princexml.com/download/prince_8.1-1_ubuntu12.04_amd64.deb'
      not_if 'test -f /tmp/prince_8.1-1_ubuntu12.04_amd64.deb'
    end
    package 'prince.deb' do
      provider Chef::Provider::Package::Dpkg
      source '/tmp/prince_8.1-1_ubuntu12.04_amd64.deb'
    end
  else
    remote_file '/tmp/prince_8.1-1_ubuntu10.04_amd64.deb' do
      source 'http://www.princexml.com/download/prince_8.1-1_ubuntu10.04_amd64.deb'
      not_if 'test -f /tmp/prince_8.1-1_ubuntu10.04_amd64.deb'
    end
    package 'prince.deb' do
      provider Chef::Provider::Package::Dpkg
      source '/tmp/prince_8.1-1_ubuntu10.04_amd64.deb'
    end
  end
elsif node['platform'] == 'centos'
  remote_file '/tmp/prince-8.1-1.centos60.x86_64.rpm' do
    source 'http://www.princexml.com/download/prince-8.1-1.centos60.x86_64.rpm'
    not_if 'test -f /tmp/prince-8.1-1.centos60.x86_64.rpm'
  end
  package 'prince.rpm' do
    provider Chef::Provider::Package::Rpm
    source '/tmp/prince-8.1-1.centos60.x86_64.rpm'
  end
end
