/*

== Class: pacemaker

Installs the pacemaker package. This class then optionally loads the cluster
configuration.

It is then your job to define the cluster resources and relationships using the
"crm" command. For more details, see http://clusterlabs.org/wiki/Documentation

Class variables:
- *$crmcli*: the configuration file we want to activate as a
  configuration file. If this attribute is not set, puppet will not manage the
  cluster's configuration.

Example usage:

  class { 'pacemaker':
    crmcli => "puppet:///modules/myproject/crm_config.cli"
  }

*/
class pacemaker (
    $crmcli = false
   ){

  case $operatingsystem {
    RedHat,CentOS: {

      case $lsbmajdistrelease {
        5,6: {

          # clusterlabs.org hosts an up to date repository for RHEL.
          yumrepo { "server_ha-clustering":
            descr => "High Availability/Clustering server technologies (RHEL_${lsbmajdistrelease})",
            baseurl => "http://www.clusterlabs.org/rpm/epel-${lsbmajdistrelease}/",
            enabled => 1,
            gpgcheck => 0,
          }

          # ensure file is managed in case we want to purge /etc/yum.repos.d/
          # http://projects.puppetlabs.com/issues/3152
          file { "/etc/yum.repos.d/server_ha-clustering.repo":
            ensure  => present,
            mode    => 0644,
            owner   => "root",
            require => Yumrepo["server_ha-clustering"],
          }

          package { "pacemaker.${architecture}":
            ensure  => present,
            alias   => "pacemaker",
          }
        }

        default: { fail("pacemaker not implemented on $operatingsystem $lsbmajdistrelease")
        }
      }
    }

    Debian: {
      package { "pacemaker":
        ensure => present
      }
    }
  }
  
  service { 'pacemaker':
    ensure => running,
    enable => true,
    hasstatus => true,
  }

  file { '/etc/pacemaker':
    ensure => directory,
  }

  if ( $crmcli ) {
    # actually load the configuration into heartbeat
    exec { "reload crm config":
      command     => "crm configure load replace /etc/pacemaker/crm-config.cli",
      refreshonly => true,
      require     => Service["pacemaker"],
    }

    # this file contains the configuration to be loaded into the cluster.
    file { "/etc/pacemaker/crm-config.cli":
      notify  => Exec["reload crm config"],
      content => template($crmcli),
      require => [ Package["pacemaker"], File ['/etc/pacemaker'], ],
    }
  }
}
