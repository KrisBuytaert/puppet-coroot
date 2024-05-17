# @summary the main coroott class
#
# @example
#   include coroot
class coroot(
  Boolean $enable_agent = false,
  Boolean $enable_server = false,
)
{
  if $enable_agent {
    include ::coroot::node_agent
  }

  if $enable_server {
    include ::coroot::server
  }
}
