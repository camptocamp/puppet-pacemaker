# == Class: pacemaker
#
# Installs the pacemaker package and heartbeat high availability service.
# This class sets up heartbeat on the nodes of the cluster, then optionally
# loads the cluster configuration.
#
# The default communication between nodes is via network broadcast.
# So mind your network and firewall settings!
#
# Once you have included this class, you should be able to see in the system
# logs that the cluster nodes are talking to each other. "crm status" should
# display all your cluster nodes as "online".
#
# It is then your job to define the cluster resources and relationships using
# the "crm" command. For more details,
# see http://clusterlabs.org/wiki/Documentation
#
#
# === Class variables
#  - *$pacemaker_authkey*: the secret key shared between cluster nodes. It is
#    required to set this attribute.
#  - *$pacemaker_crmcli*: the configuration file we want to activate as a
#    configuration file. If this attribute is not set, puppet will not manage the
#    cluster's configuration.
#  - *$pacemaker_hacf*: An alternate file to use instead of the default
#    /etc/ha.d/ha.cf defined in this class. This attribute should point to an ERB
#    template somewhere in your modulepath.
#  - *$pacemaker_port*: UDP port used in default configuration. Defaults to 691.
#  - *$pacemaker_interface*: Interface used in default configuration. Defaults to eth0.
#  - *$pacemaker_keepalive*: keepalive parameter used in default configuration. Defaults to 1.
#  - *$pacemaker_warntime*: warntime parameter used in default configuration. Defaults to 6.
#  - *$pacemaker_deadtime*: deadtime parameter used in default configuration. Defaults to 10.
#  - *$pacemaker_initdead*: initdead parameter used in default configuration. Defaults to 15.
#
#
# === Example usage
#
#    # use ha.cf template from $moduledir/mymodule/templates/myproject.ha.cf.erb
#    $pacemaker_hacf      = "mymodule/myproject.ha.cf.erb"
#    $pacemaker_crmcli    = "puppet:///modules/myproject/crm_config.cli"
#    $pacemaker_interface = "eth1"
#    $pacemaker_authkey   = "gugus"
#
#    include pacemaker
#
class pacemaker (
  $authkey   = $pacemaker::params::authkey,
  $crmcli    = $pacemaker::params::crmcli,
  $hacf      = $pacemaker::params::hacf,
  $port      = $pacemaker::params::port,
  $interface = $pacemaker::params::interface,
  $keepalive = $pacemaker::params::keepalive,
  $warntime  = $pacemaker::params::warntime,
  $deadtime  = $pacemaker::params::deadtime,
  $initdead  = $pacemaker::params::initdead,
) inherits ::pacemaker::params {

  if ( ! $authkey ) {
    fail('Mandatory variable $authkey not set')
  }


  class { '::pacemaker::install':
  } ->
  class { '::pacemaker::config':
  } ~>
  class { '::pacemaker::service':
  } ->
  class { '::pacemaker::crmcli':
  } ->
  Class['pacemaker']
}
