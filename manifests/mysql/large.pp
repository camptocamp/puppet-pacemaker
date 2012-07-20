#
# == Class: pacemaker::mysql::large
#
# Use a large mysql server with pacemaker
#
class pacemaker::mysql::large inherits mysql::server::large {
  include pacemaker::mysql::base
}
