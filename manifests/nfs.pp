/*

== Class: pacemaker::nfs

Install SELinux rules to use NFS from pacemaker

*/

class pacemaker::nfs {
  case $operatingsystem {
    RedHat: {

      case $lsbmajdistrelease {

        "4","5" : {
         }

        default: {

          selinux::module { "hanfs":
            source => "puppet:///modules/pacemaker/selinux/hanfs.te",
            require => Package["corosync"],
          }

        }

      }
    }

    default: { notice("SELinux not implemented on $operatingsystem by this module")
    }
  }

}
