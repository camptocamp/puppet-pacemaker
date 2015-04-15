# == Class: pacemaker::postgresql
#
# Helper which includes the postgresql::server class, but with service management
# disabled.  This is useful if PostgreSQL needs to be managed by Pacemaker, but you
# still want to benefit from the facilities provided in the PostgreSQL module.
#
# Requires:
# - postgresql's puppet module
#
# Example usage:
#   include pacemaker::postgresql
#
class pacemaker::postgresql {

  case $::osfamily {

    'RedHat': {
      case $::operatingsystemmajrelease {

        '4','5': { }

        default: {

          selinux::module { 'hapostgresql':
            content => file('pacemaker/selinux/hapostgresql.te'),
          }

        }
      }
    }

    default: { }

  }

}
