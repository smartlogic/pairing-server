Description
===========
Fixes a number of minor operating system-based annoyances. There are recipes per platform, currently Ubuntu and Red Hat. Feel free to fork and submit your own patches.

Recipes
=======

default
-------
Looks at the node's platform and includes the proper recipe, then removes `annoyances` from the node's run list on completion.

rhel
----
Removes any preexisting firewall rules, turns off SELinux, uninstalls apache if it's on for some reason and removes /root/.bash_logout if it exists. Red Hat, CentOS, Fedora and Scientific Linux are currently supported.

ubuntu
------
Does an "apt-get update", turns off apparmor and turns off byobu. Currently Ubuntu-only.

Usage
=====
Include the `annoyances` recipe in your run list and it will make the various changes, then remove itself from the node's run list on completion.

License and Author
==================

Author:: Matt Ray (<matt@opscode.com>)
Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright 2012 Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

