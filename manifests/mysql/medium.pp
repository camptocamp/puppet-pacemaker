#
# == Class: pacemaker::mysql::medium
#
# Use a medium mysql server with pacemaker
#
class pacemaker::mysql::medium inherits mysql::server::medium {
  include pacemaker::mysql::base
}
