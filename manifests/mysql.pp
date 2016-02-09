# == Class: pacemaker::mysql
#
# Helper which includes the mysql::server class, but with service management
# disabled.  This is useful if MySQL needs to be managed by heartbeat, but you
# still want to benefit from the facilities provided in the mysql module.
#
# Requires:
# - mysql's puppet module
#
# Example usage:
#   include pacemaker::mysql
#
class pacemaker::mysql (
  $override_options = {},
) {

  if defined('$crm_svc_mysql') {
    $create_root_user = $::crm_svc_mysql == $::hostname
  } else {
    $create_root_user = false
  }

  class {'::mysql::server':
    override_options => $override_options,
    create_root_user => $create_root_user,
    service_manage   => false,
    service_enabled  => false,
  }

}
