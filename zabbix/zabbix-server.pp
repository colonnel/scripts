node 'router' {
  class { 'apache':
    mpm_module => 'prefork',
  }
  include apache::mod::php

  class { 'mysql::server': }

  class { 'zabbix':
    zabbix_url    => 'zabbix.example.com',
    database_type => 'mysql',
  }
}

if $facts['selinux'] {
    selboolean { ['httpd_can_network_connect', 'httpd_can_network_connect_db']:
      persistent => true,
      value      => 'on',
    }
}
