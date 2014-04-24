class pacemaker::crmcli {
  if ( $pacemaker::crmcli ) {

    # actually load the configuration into heartbeat
    exec { 'reload crm config':
      command     => 'crm configure load replace /etc/ha.d/crm-config.cli',
      refreshonly => true,
    }

    # this file contains the configuration to be loaded into the cluster.
    file { '/etc/ha.d/crm-config.cli':
      source  => $pacemaker::crmcli,
      notify  => Exec['reload crm config'],
    }
  }
}
