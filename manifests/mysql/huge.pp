#
# == Class: pacemaker::mysql::huge
#
# Use a huge mysql server with pacemaker
#
class pacemaker::mysql::huge inherits mysql::server::huge {
  include pacemaker::mysql::base
}
