#! /bin/sh
PUPPET_ENV='/etc/puppetlabs/puppet'
PUPPET_BIN='/opt/puppetlabs/bin/puppet'
function install {
cd /opt
wget http://apt.puppetlabs.com/puppet5-release-stretch.deb
apt update
dpkg -i puppet5-release-stretch.deb
apt install git puppet-agent -y
}

function puppetagent_setup {
echo "alias puppetserver=$PUPPET_BIN" >> ~/.bashrc
echo "'[agent]' >> $PUPPET_ENV/puppet.conf"
echo "'server = puppetserver' >> $PUPPET_ENV/puppet.conf"
$PUPPET_BIN resource service puppet ensure=running enable=true
}

install
puppetagent_setup
