#!/bin/bash

# (with some modifications) Pilfered from https://github.com/purple52/librarian-puppet-vagrant/blob/master/shell/main.sh

# Export Ruby path, for gem and librarian-puppet.
PATH=$PATH:/opt/ruby/bin
export PATH

# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR=/etc/puppet
PUPPET_MODULE_DIR=/etc/puppet/modules

# Create the directories if they do not exist
[ -d $PUPPET_MODULE_DIR ] || mkdir -p $PUPPET_MODULE_DIR
[ -d $PUPPET_DIR ] || mkdir -p $PUPPET_DIR

# Touch the Hiera config file to make sure it exists
# It can be empty, but there will be a warning when running "vagrant up" if it does not exist
touch $PUPPET_DIR/hiera.yaml

# NB: librarian-puppet might need git installed. If it is not already installed
# in your basebox, this will manually install it at this point using apt or yum

$(which git > /dev/null 2>&1)
FOUND_GIT=$?
if [ "$FOUND_GIT" -ne '0' ]; then
  echo 'Attempting to install git.'
  $(which apt-get > /dev/null 2>&1)
  FOUND_APT=$?
  $(which yum > /dev/null 2>&1)
  FOUND_YUM=$?

  if [ "${FOUND_YUM}" -eq '0' ]; then
    yum -q -y makecache
    yum -q -y install git
    echo 'git installed.'
  elif [ "${FOUND_APT}" -eq '0' ]; then
    apt-get -q -y update
    apt-get -q -y install git
    echo 'git installed.'
  else
    echo 'No package installer available. You may need to install git manually.'
  fi
else
  echo 'git found.'
fi

cp /vagrant/puppet/Puppetfile $PUPPET_DIR

if [ "$(gem search -i librarian-puppet)" = "false" ]; then
  gem install librarian-puppet
  cd $PUPPET_DIR && librarian-puppet install --clean
else
  cd $PUPPET_DIR && librarian-puppet update
fi
