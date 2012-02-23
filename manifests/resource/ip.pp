define ha::resource::ip($ip, $nic, $resource_stickiness=absent, $unique_clone_address=false, $cidr_netmask=nil, $network=nil, $monitor_interval = "60", $monitor_timeout = "20", $monitor_on_fail = 'restart', $failure_timeout = "600", $ensure = present) {
  ha_crm_primitive { 
    "${name}":
      type                => "ocf:heartbeat:IPaddr2",
      monitor_interval    => "${monitor_interval}",
      monitor_timeout     => "${monitor_timeout}",
      monitor_on_fail     => "${monitor_on_fail}",
      ensure              => $ensure,
      require             => Service['corosync'],
      failure_timeout     => "${failure_timeout}",
      resource_stickiness => $resource_stickiness;
  }
  if $ensure != absent {
    ha_crm_parameter { 
      "${name}-addr":
        ensure    => present,
        resource  => "${name}",
        key       => "ip",
        value     => "${ip}",
        require   => Ha_Crm_Primitive["${name}"];
     "${name}-nic":
        ensure    => present,
        resource  => "${name}",
        key       => "nic",
        value     => "${nic}",
        require   => Ha_Crm_Primitive["${name}"];
      "${name}-cidr_netmask":
        ensure    => $cidr_netmask ? {
          nil     => absent,
          default => present,
        },
        resource  => "${name}",
        key       => "cidr_netmask",
        value     => "${cidr_netmask}",
        require   => Ha_Crm_Primitive["${name}"];
      "${name}-network":
        ensure    => $network ? {
          nil     => absent,
          default => present,
        },
        resource  => "${name}",
        key       => "network",
        value     => "${network}",
        require   => Ha_Crm_Primitive["${name}"];
      "${name}-unique-clone-address":
         ensure    => present,
         resource  => "${name}",
         key       => "unique_clone_address",
         value     => "${unique_clone_address}",
         require   => Ha_Crm_Primitive["${name}"];
    }
  }
}

