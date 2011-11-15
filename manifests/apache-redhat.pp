class pacemaker::apache-redhat inherits apache::redhat {

  Service["apache"] {
    ensure => undef,
    enable => false,
  }
}
