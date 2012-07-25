
# Shell stuff
package 'zsh'
package 'tmux'

# Headless testing stuff
package 'xvfb'
package 'libqt4-dev'

# Git
package 'git-core'

# Stuff to build stuff
package 'curl'

include_recipe 'build-essential'
%w(libreadline-dev zlib1g-dev libssl-dev libxml2-dev libxslt1-dev libtool).each do |pkg|
  package pkg
end

package 'vim'

if node['platform_version'] == "12.04"
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
