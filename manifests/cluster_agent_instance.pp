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


define coroot::cluster_agent_instance (
  String $coroot_address                      = 'coroot:8080',
  String $scrape_interval                     = '60s',
  Enum['running','stopped'] $ensure_running   = running,
  String $api_key                             = 'default',
  String $project                             = 'default',
  String $listen_url                           = "127.0.0.1:10301",


){


  file { "/etc/sysconfig/coroot-cluster-agent-${project}":
    group   => 0,
    mode    => '0644',
    owner   => 0,
    content => template('coroot/coroot-cluster-agent.erb'),
    before  => Service["coroot-cluster-agent@${project}"],
  }

  service{"coroot-cluster-agent@${project}":
    ensure    => $ensure_running,
    enable    => true,
    subscribe => File["/etc/sysconfig/coroot-cluster-agent-${project}"],
  }

  systemd::unit_file {"coroot-cluster-agent@${project}.service":
    content => template ('coroot/coroot-cluster-agent-service.erb'),
    before => Service["coroot-cluster-agent@${project}"],
  }


}
