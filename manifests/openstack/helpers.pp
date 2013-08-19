define hosts_file {
  $ip_address = $title  
  $host_name = "${hostname}"
  $fqdn = "${fqdn}" 

  file { "hosts-${title}":
    path    => "/etc/hosts",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('hosts.erb'),
  }
}

define interfaces {
  file { "interfaces":
    path    => "/etc/network/interfaces",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('interfaces.erb'),
  }
  
  exec { "ifup -a":
    subscribe => File['interfaces'],
    path      => ["/sbin/"],
  }
}

define cinder_extend($drive = $title) {
  Exec { path => ["/sbin/"], }
  exec { "mkpart${drive}":
    command => "parted -a optimal --script /dev/sd${drive} -- mkpart primary 0% 100%",
    creates => "/dev/sd${drive}1",
  }
  exec { "lvmflag${drive}":
    command   => "parted -a optimal --script /dev/sd${drive} -- set 1 lvm on",
    refreshonly => true,
    subscribe => Exec["mkpart${drive}"],
  }
  exec { "pvcreate${drive}":
    command   => "pvcreate /dev/sd${drive}1",
    refreshonly => true,
    subscribe => Exec["lvmflag${drive}"], 
  }
  exec { "vgextend${drive}":
    command   => "vgextend cinder-volumes /dev/sd${drive}1",
    refreshonly => true,
    subscribe => Exec["pvcreate${drive}"], 
  }
}
