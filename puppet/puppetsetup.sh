#! /bin/sh
PUPPET_ENV='/etc/puppetlabs/'
PUPPET_BIN='/opt/puppetlabs/bin/puppet'
function install {
cd /opt
wget http://apt.puppetlabs.com/puppet5-release-stretch.deb
apt update
dpkg -i puppet5-release-stretch.deb
apt install git puppetserver -y
}

function puppetserver_setup {
if [ -d $PUPPET_ENV ]
then
mv $PUPPET_ENV /etc/puppetlabs-bak
fi
git clone https://github.com/colonnel/puppet.git /etc/puppetlabs
echo "alias puppetserver=$PUPPET_BIN" >> ~/.bashrc
$PUPPET_BIN resource service puppetserver ensure=running enable=true
}

install
puppetserver_setup
