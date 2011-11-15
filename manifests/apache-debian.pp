class pacemaker::apache-debian inherits apache::debian {

  Service["apache"] {
    ensure => undef,
    enable => false,
  }
}
