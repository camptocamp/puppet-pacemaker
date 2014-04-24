class pacemaker::params {
  $authkey = $pacemaker_authkey

  $port = $pacemaker_port ? {
    undef   => '691',
    default => $pacemaker_port,
  }

  $interface = $pacemaker_interface ? {
    undef   => 'eth0',
    default => $pacemaker_interface,
  }

  $keepalive = $pacemaker_keepalive ? {
    undef   => '1',
    default => $pacemaker_keepalive,
  }

  $warntime = $pacemaker_warntime ? {
    undef   => '6',
    default => $pacemaker_warntime,
  }

  $deadtime = $pacemaker_deadtime ? {
    undef   => '10',
    default => $pacemaker_deadtime,
  }

  $initdead = $pacemaker_initdead ? {
    undef   => '15',
    default => $pacemaker_initdead,
  }

  $crmcli = $pacemaker_crmcli

  $hacf = $pacemaker_hacf
}
