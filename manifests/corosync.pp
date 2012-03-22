#
# = Class pacemaker::corosync
# Install and configure the corosync cluster communication services.
#
# = Parameters
#
# $ringnumber:: THe corosync ring number (optional)
#
# $mcastaddr:: The multicast IP for cluster communications. default 226.94.1.1
#
# $mcastport:: The multicast port or cluster communications. default 4000
#
# $authkey_file:: The source path for the corosync authkey
#
# $conf_template:: The path to the corosync.conf template.
class pacemaker::corosync (
    $ringnumber = '0',
    $mcastaddr = '226.94.1.1',
    $mcastport = '4000',
    $bindnetaddr,
    $authkey_file,
    $conf_template
  ){

  case $operatingsystem {
    RedHat,CentOS: {

      case $lsbmajdistrelease {
        "6": {

          package { "corosync":
            ensure  => present,
          }

          # Me thinks these should be created by the packages, but, well, it's not Debian..
          file { "/var/run/crm":
            ensure  => directory,
            owner   => "hacluster",
            group   => "haclient",
            mode    => 0755,
            require => package["corosync"],
          }
          file { "/var/run/heartbeat":
            ensure  => directory,
            owner   => "root",
            group   => "root",
            mode    => 0755,
          }

          Service ["corosync"] {
            require => [ Package["corosync"], File["/etc/corosync/authkey"], File["/etc/corosync/corosync.conf"],
                         File["/var/run/crm"], File["/var/run/heartbeat"] ],
          }
        }

        default: { fail("pacemaker::corosync not implemented on $operatingsystem $lsbmajdistrelease")
        }
      }
    }

    Debian: {
      case $lsbmajdistrelease {

        "6": {

          package { ["pacemaker", "corosync"]:
            ensure => present
          }

          Service ["corosync"] {
            require => [ Package["corosync"], File["/etc/corosync/authkey"], File["/etc/corosync/corosync.conf"] ],
          }

          augeas { "corosync start on boot" :
            context => "/files/etc/default/corosync",
            changes => [ "set START yes" ],
          }

        }

        default: { fail("pacemaker::corosync not implemented on $operatingsystem $lsbmajdistrelease")
        }

      }
    }

    default: { fail("pacemaker::corosync not implemented on $operatingsystem")
    }
  }

  file { "/etc/corosync/corosync.conf":
    owner   => "root",
    group   => "root",
    mode    => 0600,
    content => template($conf_template),
    require => Package["corosync"],
  }

  file { "/etc/corosync/authkey":
    owner   => "root",
    group   => "root",
    mode    => 0400,
    source  => $authkey_file,
    require => Package["corosync"],
  }

  service { "corosync":
    ensure    => running,
    hasstatus => true,
    enable    => true,
  }

}
