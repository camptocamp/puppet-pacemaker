class pacemaker::apache-redhat inherits apache_c2c::redhat {

  Service["apache"] {
    ensure => undef,
    enable => false,
  }
}
