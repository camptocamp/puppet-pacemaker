#
# == Class: pacemaker::mysql::unmanaged
#
# Use a unmanaged mysql server with pacemaker
#
class pacemaker::mysql::unmanaged inherits mysql::server::unmanaged {
  include pacemaker::mysql::base
}
