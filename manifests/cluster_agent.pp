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


class  coroot::cluster_agent (
  Boolean $manage_package                     = true,  # Assuming a package / rpm / deb is in the configured repository and can be installed
  String $package_name                        = 'coroot-cluster-agent',
  Enum['present','absent']  $ensure_installed = present,


){

  if $manage_package {
    package {$package_name:
      ensure => $ensure_installed,
    }
  }


}
