class pacemaker::config {
  file { '/etc/ha.d/authkeys':
    content => "auth 1\n1 sha1 ${pacemaker::authkey}\n",
    owner   => 'root',
    mode    => '0600',
  }

  # heartbeat configuration file, which can be either an ERB template located
  # at $pacemaker_hacf, or the default file shipped with this module.
  file { '/etc/ha.d/ha.cf':
    content => $pacemaker::hacf ? {
      ''      => template('pacemaker/ha.cf.erb'),
      default => template($pacemaker::hacf),
    },
  }
}
