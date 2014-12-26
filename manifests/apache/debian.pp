# lint:ignore:inherits_across_namespaces
class pacemaker::apache::debian inherits apache_c2c::debian {
# lint:endignore

  Service['httpd'] {
    ensure => undef,
    enable => false,
  }
}
