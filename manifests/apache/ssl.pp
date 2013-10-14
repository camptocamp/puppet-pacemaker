/*

== Class: pacemaker::apache::ssl

Companion class for pacemaker::apache

Requires:
- apache's puppet module

Example usage:
  include pacemaker::apache
  include pacemaker::apache::ssl
  apache_c2c::vhost {$fqdn: ensure => present }

*/
class pacemaker::apache::ssl {

  case $operatingsystem {

    RedHat: {
      include apache_c2c::ssl::redhat
    }

    Debian: {
      include apache_c2c::ssl::debian
    }
  }
}
