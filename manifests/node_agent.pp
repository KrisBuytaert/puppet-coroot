# @summary This class installs the coroot_node_agent
#
# @example
#   include coroot::node_agent
#
# @param  coroot_address
# The url of your coroot server
# @param  manage_package
# To manage the package or not
# @param  package_name
# The name of the agent package
# @param  scrape_interval
# The scrape interval for the metrics
# @param  ensure_installed
# Install or remove the package
# @param  ensure_running
# Stop or start the service
# @param  api_key
# The API key to configure the project


class coroot::node_agent (
  String $coroot_address                      = 'coroot:8080',
  Boolean $manage_package                     = true,  # Assuming a package / rpm / deb is in the configured repository and can be installed
  String $package_name                        = 'coroot-node-agent',
  String $scrape_interval                     = '15s',
  Enum['present','absent']  $ensure_installed = present,
  Enum['running','stopped'] $ensure_running   = running,
  String $api_key                             = '',


){

  if $manage_package {
    package {$package_name:
      ensure => $ensure_installed,
      before => Service['coroot-node-agent'],
    }
  }

  file { '/etc/sysconfig/coroot-node-agent':
    group   => 0,
    mode    => '0644',
    owner   => 0,
    content => template('coroot/coroot-node-agent.erb'),
    before => Service['coroot-node-agent'],
  }

  service{'coroot-node-agent':
    ensure    => $ensure_running,
    enable    => true,
    subscribe => File['/etc/sysconfig/coroot-node-agent'],
  }

  systemd::unit_file {'coroot-node-agent.service':
    source => "puppet:///modules/${module_name}/coroot-node-agent.service",
    before => Service['coroot-node-agent'],
  }


}
