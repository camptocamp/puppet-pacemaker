#
# == Definition: pacemaker::cman::iptables
# 
# A helper which allows setting iptables rules for pacemaker with cman.
# Work only with 2 servers.
# 
# Parameters:
# - *$ip1*: ip v4 address of the first server
# - *$ip2*: ip v4 address of the second server
# - *$mcastip*: ip v4 multicast address to be used between the servers
# - *$subnetrouter*: ip v4 address were all-hosts igmp packet are comming from
# - *$port*: port to be used (and port - 1)
# If you don't use this default port, you may have trouble with SELinux.
# 
# Example usage:
# 
#   pacemaker::cman::iptables { 'demo': ip1 => "192.168.0.2", ip2 => "192.168.0.3", mcastip => "239.0.0.11", subnetrouteur => "192.168.0.1" }
# 
define pacemaker::cman::iptables (
  $ip1="127.0.0.1",
  $ip2="127.0.0.1",
  $mcastip="127.0.0.1",
  $subnetrouter="127.0.0.1",
  $port="5405",
) {

  # open igmp from router to mcast
  firewall { "100 cluster ${subnetrouter} to all-hosts group":
    action      => 'accept',
    proto       => 'igmp',
    source      => $subnetrouter,
    destination => '224.0.0.1',
  }

  firewall { "100 cluster ${subnetrouter} to ${mcastip}":
    action      => 'accept',
    proto       => 'igmp',
    source      => $subnetrouter,
    destination => $mcastip,
  }

  # open upd port $port between each servers
  firewall { "100 cluster allow udp from ${ip1} to ${ip2}":
    action      => 'accept',
    proto       => 'udp',
    source      => $ip1,
    destination => $ip2,
  }

  firewall { "100 cluster allow udp from ${ip2} to ${ip1}":
    action      => 'accept',
    proto       => 'udp',
    source      => $ip2,
    destination => $ip1,
  }

  # open udp port between each server and the multicast address
  firewall { "100 cluster allow udp from ${ip1} to ${mcastip}":
    action      => 'accept',
    proto       => 'udp',
    source      => $ip1,
    destination => $mcastip,
    sport       => $port - 1,
    dport       => $port,
  }

  firewall { "100 cluster allow udp from ${ip2} to ${mcastip}":
    action      => 'accept',
    proto       => 'udp',
    source      => $ip2,
    destination => $mcastip,
    sport       => $port - 1,
    dport       => $port,
  }

  # Allow igmp from each server to multicast address
  firewall { "100 cluster allow igmp from ${ip1} to ${mcastip}":
    action      => 'accept',
    proto       => 'igmp',
    source      => $ip1,
    destination => $mcastip,
  }

  firewall { "100 cluster allow igmp from ${ip2} to ${mcastip}":
    action      => 'accept',
    proto       => 'igmp',
    source      => $ip2,
    destination => $mcastip,
  }

}
# EOF
