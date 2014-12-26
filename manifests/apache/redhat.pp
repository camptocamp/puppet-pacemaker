# lint:ignore:inherits_across_namespaces
class pacemaker::apache::redhat inherits apache_c2c::redhat {
# lint:endignore

  Service['httpd'] {
    ensure => undef,
    enable => false,
  }
}
