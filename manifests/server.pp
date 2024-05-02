# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include coroot::server
class coroot::server(
  String $listen_address   = '0.0.0.0:8080',
  String $bootstrap_clickhouse_address = 'clickhouse:9000',
  String $bootstrap_prometheus_url     = 'http://prometheus:9090/',
  String $bootstrap_refresh_interval   = '15s',
  Boolean $disable_usage_statistics    = false,
  Boolean $manage_package              = true,
  String $package_name                 = 'coroot',
  String $clickhouse_database          = 'coroot',
  String $extra_options                = '',
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
    content => template('coroot/coroot.service.erb'),
  }

  if $disable_usage_statistics {
    notify {'disabled':  }
    $full_options = "$extra_options --disable-usage-statistics"
  }




}
