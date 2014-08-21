#
# == Class: pacemaker::cman
#
# Install composants for using pacemaker with cman
#
class pacemaker::cman (
  $corosync_mcast_address = hiera( 'corosync::multicast_address' ),
  $corosync_mcast_port    = hiera( 'corosync::multicast_port', 5405 ),
) {

  # RHEL6.4+
  $packages = [ 'pacemaker', 'cman', 'pcs' ]

  package { $packages:
    ensure => present,
  }

}
