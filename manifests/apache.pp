/*

== Class: pacemaker::apache

Helper which includes the apache module, but with service management disabled.
This is useful if your apache server needs to be managed by heartbeat, but you
still want to benefit from the facilities provided in the apache module.

Requires:
- apache's puppet module

Example usage:
  include pacemaker::apache
  apache::vhost {$fqdn: ensure => present }

*/
class pacemaker::apache {

  case $operatingsystem {

    RedHat: {
      include pacemaker::apache-redhat
    }

    Debian: {
      include pacemaker::apache-debian
    }
  }
}
