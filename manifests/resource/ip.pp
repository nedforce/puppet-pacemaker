define ha::resource::ip($ip, $nic, $resource_stickiness=absent, $unique_clone_address=false, $ensure = present) {
  ha_crm_primitive { 
    "${name}":
      type    => "ocf:heartbeat:IPaddr2",
      #monitor_interval => "20",
      ensure           => $ensure,
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
      "${name}-unique-clone-address":
         ensure    => present,
         resource  => "${name}",
         key       => "unique_clone_address",
         value     => "${unique_clone_address}",
         require   => Ha_Crm_Primitive["${name}"];
    }
  }
}

