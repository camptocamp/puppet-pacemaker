/*

== Definition: pacemaker::corosync::iptables

A helper which allows setting iptables rules for pacemaker.

Parameters:
- *$name*: the address or address block you want to allow heartbeat packets
  from.

Example usage:

  pacemaker::iptables {"10.0.1.0/24": port => "1234" }
  pacemaker::iptables {["192.168.0.2", "192.168.0.3"]: }

*/
define pacemaker::corosync::iptables ($ip1="127.0.0.1", $ip2="127.0.0.1", $corosync_mcast_ip="127.0.0.1", $mcast_router="") {

#  iptables { "allow pacemaker from $name on port $port":
#    proto => "udp",
#    dport => $port,
#    source => $name,
#    jump => "ACCEPT",
#  }

  if $mcast_router == "" {
    $router = regsubst($ip1,'^([.0-9]*)\.[0-9]{1,3}$', '\1.1')
  }

  # open udp and igmp ports for both servers and multicast address
  iptables { "corosync: allow igmp from $mcast_router to 224.0.0.1":
    proto  => "igmp",
    source => $mcast_router,
    destination => "224.0.0.1",
    jump   => "ACCEPT",
  }

  iptables { "corosync: allow udp from $mcast_router to $corosync_mcast_ip":
    proto  => "udp",
    source => $mcast_router,
    destination => $corosync_mcast_ip,
    jump   => "ACCEPT",
  }

  iptables { "corosync: allow igmp from $mcast_router to $corosync_mcast_ip":
    proto  => "igmp",
    source => $mcast_router,
    destination => $corosync_mcast_ip,
    jump   => "ACCEPT",
  }

  iptables { "corosync: allow udp from $ip1 to $corosync_mcast_ip":
    proto  => "udp",
    source => $ip1,
    destination => $corosync_mcast_ip,
    jump   => "ACCEPT",
  }

  iptables { "corosync: allow udp from $ip2 to $corosync_mcast_ip":
    proto  => "udp",
    source => $ip2,
    destination => $corosync_mcast_ip,
    jump   => "ACCEPT",
  }

  iptables { "corosync: allow igmp from $ip1 to $corosync_mcast_ip":
    proto  => "igmp",
    source => $ip1,
    destination => $corosync_mcast_ip,
    jump   => "ACCEPT",
  }

  iptables { "corosync: allow igmp from $ip2 to $corosync_mcast_ip":
    proto  => "igmp",
    source => $ip2,
    destination => $corosync_mcast_ip,
    jump   => "ACCEPT",
  }

  iptables { "corosync: allow udp from $ip1, to $ip2":
    proto  => "udp",
    source => $ip1,
    destination => $ip2,
    jump   => "ACCEPT",
  }

  iptables { "corosync: allow udp from $ip2, to $ip1":
    proto  => "udp",
    source => $ip2,
    destination => $ip1,
    jump   => "ACCEPT",
  }

}
# EOF
