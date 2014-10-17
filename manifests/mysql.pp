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
  $performance = undef,
  $config_override = {},
) {
  class {'::mysql::server':
    performance        => $performance,
    config_override    => $config_override,
    unmanaged_password => ($::crm_svc_mysql != $::hostname),
    unmanaged_service  => true,
  }
}
