#
# == Class: pacemaker::mysql::small
#
# Use a small mysql server with pacemaker
#
class pacemaker::mysql::small inherits mysql::server::small {
  include pacemaker::mysql::base
}
