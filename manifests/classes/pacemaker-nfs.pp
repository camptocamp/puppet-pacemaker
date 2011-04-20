/*

== Class: pacemaker::nfs

Install SELinux rules to use NFS from pacemaker

*/

class pacemaker::nfs {
  case $operatingsystem {
    RedHat: {

      case $lsbmajdistrelease {
        "6": {

          selinux::module { "hanfs":
            source => "puppet:///pacemaker/selinux/hanfs.te",
            notify => Selmodule["hanfs"],
            require => Package["corosync"],
          }

          selmodule { "hanfs":
            ensure => present,
            syncversion => true,
            require => Exec["build selinux policy package hanfs"],
          }

        }

        default: { 
        }
      }
    }

    default: { notice("SELinux not implemented on $operatingsystem by this module")
    }
  }

}
