/*

== Class: pacemaker::apache::ssl

Companion class for pacemaker::apache

Requires:
- apache's puppet module

Example usage:
  include pacemaker::apache
  include pacemaker::apache::ssl
  apache::vhost {$fqdn: ensure => present }

*/
class pacemaker::apache::ssl {

  case $operatingsystem {

    RedHat: {
      include apache::ssl::redhat
    }

    Debian: {
      include apache::ssl::debian
    }
  }
}
