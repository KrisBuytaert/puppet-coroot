# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include coroot::server
class coroot::node_agent (
  String $coroot_address   = 'coroot:8080',
  Boolean $manage_package              = true,
  String $package_name                 = 'coroot-node-agent',
  String $scrape_interval   = '15s',

){

  if $manage_package {
    package {$package_name:
      ensure => present,
    }
  }

  file { '/etc/sysconfig/coroot-node-agent':
    group   => 0,
    mode    => '0644',
    owner   => 0,
    content => template('coroot/coroot-node-agent.erb'),
  }

  service{'coroot-node-agent':
    ensure    => 'running',
    enable    => true,
    subscribe => File['/etc/sysconfig/coroot-node-agent'],
  }

  systemd::unit_file {'coroot-node-agent.service':
    source => "puppet:///modules/${module_name}/coroot-node-agent.service"
  }


}
