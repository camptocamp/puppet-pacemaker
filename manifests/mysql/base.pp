/*

== Class: pacemaker::mysql::base

*/
class pacemaker::mysql::base inherits mysql::server::base {
  Service["mysql"] {
    ensure     => undef,
    enable     => false,
    hasrestart => true,
    restart    => "service mysqld condrestart",
  }
}
