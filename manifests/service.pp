class pacemaker::service {
  service { 'heartbeat':
    ensure    => running,
    hasstatus => true,
    enable    => true,
  }
}
