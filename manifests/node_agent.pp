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
  Enum['present','absent']  $ensure_installed = present,
  Enum['started','stopped'] $ensure_running   = started,



){

  if $manage_package {
    package {$package_name:
      ensure => $ensure_installed,
    }
  }

  file { '/etc/sysconfig/coroot-node-agent':
    group   => 0,
    mode    => '0644',
    owner   => 0,
    content => template('coroot/coroot-node-agent.erb'),
  }

  service{'coroot-node-agent':
    ensure    => $ensure_running,
    enable    => true,
    subscribe => File['/etc/sysconfig/coroot-node-agent'],
  }

  systemd::unit_file {'coroot-node-agent.service':
    source => "puppet:///modules/${module_name}/coroot-node-agent.service"
  }


}
