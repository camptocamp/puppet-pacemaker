class pacemaker::apache-redhat inherits apache_c2c::redhat {

  Service['httpd'] {
    ensure => undef,
    enable => false,
  }
}
