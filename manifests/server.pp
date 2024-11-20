# @summary This class installs the coroot server
#
# @example
# include coroot::server
#
# @param listen_address
# The address and port coroot wil listen on  
# @param bootstrap_clickhouse_address
# The bootstrap url for clickhouse
# @param bootstrap_prometheus_url 
# The bootstrap url for prometheus
# @param bootstrap_refresh_interval
# The bootstrap refresh_interval 
# @param disable_usage_statistics
# If set to false no usage statistics will be sent
# @param manage_package
# Whether to manage the package or not , default true
# @param package_name
# The name of the package to be installed
# @param clickhouse_database
# The name of the (bootstrap) clickhouse database
# @param extra_options
# Extra options to pass to the service at startup
class coroot::server(
  String $listen_address               = '0.0.0.0:8080',
  # This only sets the parameters at bootstrap, additional config is still from 
  # the UI.
  String $bootstrap_clickhouse_address = 'clickhouse:9000',
  Optional[String] $bootstrap_clickhouse_user    = undef,
  Optional[String] $bootstrap_clickhouse_password    = undef,
  Optional[String] $bootstrap_clickhouse_database    = undef,
  String $bootstrap_prometheus_url     = 'http://prometheus:9090/',
  Optional[String] $bootstrap_prometheus_extra_slector     = undef,
  String $bootstrap_refresh_interval   = '15s',
  Optional[String] $pgsql_connection   = '',
  Boolean $disable_usage_statistics    = false,
  Boolean $disable_slo    = false,
  Boolean $disable_deployments    = false,
  Boolean $disable_check_for_updates    = false,
  Boolean $manage_package              = true,
  String $package_name                 = 'coroot',
  String $clickhouse_database          = 'coroot',
  String $extra_options                = '',
  Boolean $enable_cluster_agent        = false,
){

  if $manage_package {
    package {$package_name:
      ensure => present,
    }
  }

  if $enable_cluster_agent {
    include  coroot::cluster_agent
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


  if $disable_slo {
    $_slo_options = ' --do-not-check-slo '
  }

  if $disable_deployments {
    $_deploy_options = ' --do-not-check-for-deployments '
  }

  if $disable_check_for_updates {
    $_update_options = ' --do-not-check-for-updates '
  }

  if $disable_usage_statistics {
    $_stat_options = "${extra_options} --disable-usage-statistics"
  }
  if  $pgsql_connection  !=  '' {
    $_pgsql_options = "--pg-connection-string=\"${pgsql_connection}\""
  }

  $full_options = "${_stat_options} ${_pgsql_options} ${_slo_options} ${_deploy_options} ${_update_options} "

  systemd::unit_file {'coroot.service':
    content => template('coroot/coroot.service.erb'),
  }

}
