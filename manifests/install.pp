class pacemaker::install {
  case $::osfamily {
    'RedHat': {

      case $::lsbmajdistrelease {
        '5': {

          # clusterlabs.org hosts an up to date repository for RHEL.
          yumrepo { 'server_ha-clustering':
            descr    => "High Availability/Clustering server technologies (RHEL_${::lsbmajdistrelease})",
            baseurl  => "http://www.clusterlabs.org/rpm/epel-${::lsbmajdistrelease}/",
            enabled  => 1,
            gpgcheck => 0,
          } ->
          # ensure file is managed in case we want to purge /etc/yum.repos.d/
          # http://projects.puppetlabs.com/issues/3152
          file { '/etc/yum.repos.d/server_ha-clustering.repo':
            ensure  => present,
            mode    => '0644',
            owner   => 'root',
          }

          package { "heartbeat.${::architecture}":
            ensure => present,
            alias  => 'heartbeat',
          } ->
          package { "pacemaker.${::architecture}":
            ensure  => present,
            alias   => 'pacemaker',
          }
        }

        default: { fail("pacemaker not implemented on ${::operatingsystem} ${::lsbmajdistrelease}")
        }
      }
    }

    'Debian': {
      package { ['pacemaker', 'heartbeat']:
        ensure => present,
      }
    }
  }
}
