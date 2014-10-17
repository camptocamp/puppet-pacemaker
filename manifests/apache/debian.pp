class pacemaker::apache::debian inherits apache_c2c::debian {

  Service['httpd'] {
    ensure => undef,
    enable => false,
  }
}
