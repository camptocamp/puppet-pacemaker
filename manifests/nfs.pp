/*

== Class: pacemaker::nfs

Install SELinux rules to use NFS from pacemaker

*/

class pacemaker::nfs {
  case $operatingsystem {
    RedHat,CentOS: {

      case $lsbmajdistrelease {

        "4","5" : {
         }

        default: {

          selinux::module { "hanfs":
            source => "puppet:///modules/pacemaker/selinux/hanfs.te",
            notify => Selmodule["hanfs"],
            require => Package["corosync"],
          }

          selmodule { "hanfs":
            ensure => present,
            syncversion => true,
            require => Exec["build selinux policy package hanfs"],
          }

        }

      }
    }

    default: { notice("SELinux not implemented on $operatingsystem by this module")
    }
  }

}
