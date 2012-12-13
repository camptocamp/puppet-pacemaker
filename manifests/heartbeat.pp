/*

== Class: pacemaker

Installs the pacemaker package and heartbeat high availability service. This
class sets up heartbeat on the nodes of the cluster, then optionally loads the
cluster configuration.

The default communication between nodes is via network broadcast. So mind your
network and firewall settings !

Once you have included this class, you should be able to see in the system logs
that the cluster nodes are talking to each other. "crm status" should display all
your cluster nodes as "online".

It is then your job to define the cluster resources and relationships using the
"crm" command. For more details, see http://clusterlabs.org/wiki/Documentation


Class variables:
- *$authkey*: the secret key shared between cluster nodes. It is
  required to set this attribute.
- *$hacf*: An alternate file to use instead of the default
  /etc/ha.d/ha.cf defined in this class. This attribute should point to an ERB
  template somewhere in your modulepath.
- *$port*: UDP port used in default configuration. Defaults to 691.
- *$interface*: Interface used in default configuration. Defaults to eth0.
- *$keepalive*: keepalive parameter used in default configuration. Defaults to 1.
- *$warntime*: warntime parameter used in default configuration. Defaults to 6.
- *$deadtime*: deadtime parameter used in default configuration. Defaults to 10.
- *$initdead*: initdead parameter used in default configuration. Defaults to 15.

Example usage:


  class { 'pacemaker':
     hacf      => "mymodule/myproject.ha.cf.erb"
     authkey   => "gugus"
   }
*/
class pacemaker::heartbeat(
    $authkey,
    $hacf,
    $port = "691",
    $interface = "eth0",
    $keepalive = "1",
    $warntime = "6",
    $deadtime = "10",
    $initdead = "15") {

    package { "heartbeat.${architecture}":
        ensure => present,
        alias  => "heartbeat",
    }

    file { "/etc/ha.d/authkeys":
      content => "auth 1\n1 sha1 ${authkey}\n",
      owner   => "root",
      mode    => 0600,
      notify  => Service["heartbeat"],
      require => Package["heartbeat"],
    }

    # heartbeat configuration file, which can be either an ERB template located
    # at $pacemaker_hacf, or the default file shipped with this module.
    file { "/etc/ha.d/ha.cf":
      content => $hacf ? {
        default => template($hacf),
        ""      => template("pacemaker/ha.cf.erb"),
      },
      notify  => Service["heartbeat"],
      require => Package["heartbeat"],
    }

    service { "heartbeat":
      ensure    => running,
      hasstatus => true,
      enable    => true,
      require   => Package["heartbeat"],
    }
}