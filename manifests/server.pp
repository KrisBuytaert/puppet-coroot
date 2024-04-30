# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include coroot::server
class coroot::server (
  String $listen_address   = '0.0.0.0:8080',
  String $bootstrap_clickhouse_address = 'clickhouse:9000',
  String $bootstrap_prometheus_url     = 'http://prometheus:9090/',
  String $bootstrap_refresh_interval   = '15s',
  Boolean $manage_package              = true,
  String $package_name                 = 'coroot',

){

  if $manage_package {
    package {$package_name:
      ensure => present,
    }
  }

  file { '/etc/sysconfig/coroot':
    group   => 0,
    mode    => '0644',
    owner   => 0,
    content => template('coroot/coroot.erb'),
  }

  service{'coroot':
    ensure    => 'running',
    enable    => true,
    subscribe => File['/etc/sysconfig/coroot'],
  }

  systemd::unit_file {'coroot.service':
    source => "puppet:///modules/${module_name}/coroot.service"
  }


}
