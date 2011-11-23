class pacemaker::corosync {
  # TODO: put this variables in pacemaker::corosync:params

  if ( ! $corosync_mcast_ip      ) { fail("Mandatory variable \$corosync_mcast_ip not set") }
  if ( ! $corosync_mcast_port    ) { fail("Mandatory variable \$corosync_mcast_port not set") }
  if ( ! $corosync_authkey_file  ) { fail("Mandatory variable \$corosync_authkey_file not set") }
  if ( ! $corosync_conf_template ) { fail("Mandatory variable \$corosync_conf_template not set") }

  if ( ! $pacemaker_authkey )   { fail("Mandatory variable \$pacemaker_authkey not set") }

  if ( ! $pacemaker_interface ) { $pacemaker_interface = "eth0" }
  if ( ! $pacemaker_keepalive ) { $pacemaker_keepalive = "1" }
  if ( ! $pacemaker_warntime )  { $pacemaker_warntime = "6" }
  if ( ! $pacemaker_deadtime )  { $pacemaker_deadtime = "10" }
  if ( ! $pacemaker_initdead )  { $pacemaker_initdead = "15" }

  case $operatingsystem {
    RedHat: {

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
