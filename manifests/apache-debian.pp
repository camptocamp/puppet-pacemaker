class pacemaker::apache-debian inherits apache_c2c::debian {

  Service["apache"] {
    ensure => undef,
    enable => false,
  }
}
