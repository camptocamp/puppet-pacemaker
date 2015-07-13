#
# == Class: pacemaker::corosync
#
# $pacemaker_log_time_unit: a valid value for logrotate: daily, monthly, weekly
class pacemaker::corosync(
  $corosync_mcast_ip,
  $corosync_mcast_port,
  $corosync_authkey_file,
  $pacemaker_authkey,
  $corosync_conf_template       = undef,
  $corosync_conf_content        = undef,
  $pacemaker_interface          = 'eth0',
  $pacemaker_keepalive          = 1,
  $pacemaker_warntime           = 6,
  $pacemaker_deadtime           = 10,
  $pacemaker_initdead           = 15,
  # For logrotate configuration
  $pacemaker_logrotate_template = undef,
  $pacemaker_logrotate_content  = undef,
  $pacemaker_log_units_hold     = 32,
  $pacemaker_log_time_unit      = 'daily',
) {

  case $::operatingsystem {
    'RedHat': {

      case $::operatingsystemmajrelease {
        '6': {

          package { 'pacemaker':
            ensure  => present,
            require => Package['corosync'],
          }

          package { 'corosync':
            ensure  => present,
          }

          selinux::module { 'ha':
            content => file('pacemaker/selinux/ha.te'),
            require => Package['corosync'],
          }

          # Me thinks these should be created by the packages, but, well, it's not Debian..
          file { '/var/run/crm':
            ensure  => directory,
            owner   => 'hacluster',
            group   => 'haclient',
            mode    => '0755',
            require => Package['corosync'],
          }
          file { '/var/run/heartbeat':
            ensure => directory,
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
          }

          Service['corosync'] {
            require => [ Package['corosync'], File['/etc/corosync/authkey'], File['/etc/corosync/corosync.conf'],
                        File['/var/run/crm'], File['/var/run/heartbeat'] ],
          }
        }

        default: { fail("pacemaker::corosync not implemented on ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }

    'Debian': {
      case $::lsbmajdistrelease {

        '6': {

          package { ['pacemaker', 'corosync']:
            ensure => present,
          }

          Service['corosync'] {
            require => [ Package['corosync'], File['/etc/corosync/authkey'], File['/etc/corosync/corosync.conf'] ],
          }

          augeas { 'corosync start on boot' :
            context => '/files/etc/default/corosync',
            changes => [ 'set START yes' ],
          }

        }

        default: { fail("pacemaker::corosync not implemented on ${::operatingsystem} ${::lsbmajdistrelease}")
        }

      }
    }

    default: { fail("pacemaker::corosync not implemented on ${::operatingsystem}")
    }
  }

  if $corosync_conf_content and $corosync_conf_template {
    fail 'Cannot pass both $corosync_conf_content and $corosync_conf_template'
  }

  if $corosync_conf_template {
    warning 'Using $corosync_conf_template is deprecated. Using $corosync_conf_content instead.'
    $_corosync_conf_content = template($corosync_conf_template)
  } elsif ($corosync_conf_content) {
    $_corosync_conf_content = $corosync_conf_content
  } else {
    fail 'You must pass either $corosync_conf_content or $corosync_conf_template'
  }

  file { '/etc/corosync/corosync.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $_corosync_conf_content,
    require => Package['corosync'],
  }

  file { '/etc/corosync/authkey':
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    source  => $corosync_authkey_file,
    require => Package['corosync'],
  }

  if $pacemaker_logrotate_content and $pacemaker_logrotate_template {
    fail 'Cannot pass both $pacemaker_logrotate_content and $pacemaker_logrotate_template'
  }

  if $pacemaker_logrotate_template {
    warning 'Using $pacemaker_logrotate_template is deprecated. Using $pacemaker_logrotate_content instead.'
    $_pacemaker_logrotate_content = template($pacemaker_logrotate_template)
  } elsif ($pacemaker_logrotate_content) {
    $_pacemaker_logrotate_content = $pacemaker_logrotate_content
  } else {
    $_pacemaker_logrotate_content = template('pacemaker/corosync.logrotate.erb')
  }

  file { '/etc/logrotate.d/corosync':
    ensure  => file,
    owner   => root,
    group   => root,
    content => $_pacemaker_logrotate_content,
    replace => false,
  }

  service { 'corosync':
    ensure    => running,
    hasstatus => true,
    enable    => true,
  }

}
