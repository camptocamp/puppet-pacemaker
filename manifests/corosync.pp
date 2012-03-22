#
# = Class pacemaker::corosync
# Install and configure the corosync cluster communication services.
#
# = Parameters
#
# $corosync_mcast_ip:: The multicast IP for cluster communications
#
# $corosync_mcast_port:: The multicast port or cluster communications
#
# $corosync_authkey_file:: The source path for the corosync authkey
#
class pacemaker::corosync (
    $corosync_mcast_ip,
    $corosync_mcast_port,
    $corosync_authkey_file,
    $corosync_conf_template
  ){

  case $operatingsystem {
    RedHat,CentOS: {

      case $lsbmajdistrelease {
        "6": {

          package { "pacemaker":
            ensure  => present,
            require => Package["corosync"],
          }

          package { "corosync":
            ensure  => present,
          }

          selinux::module { "ha":
            source => "puppet:///modules/pacemaker/selinux/ha.te",
            notify => Selmodule["ha"],
            require => Package["corosync"],
          }

          selmodule { "ha":
            ensure => present,
            syncversion => true,
            require => Exec["build selinux policy package ha"],
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
    content => template("$corosync_conf_template"),
    require => Package["corosync"],
  }

  file { "/etc/corosync/authkey":
    owner   => "root",
    group   => "root",
    mode    => 0400,
    source  => $corosync_authkey_file,
    require => Package["corosync"],
  }

  service { "corosync":
    ensure    => running,
    hasstatus => true,
    enable    => true,
  }

}
