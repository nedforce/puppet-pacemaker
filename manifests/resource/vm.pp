define ha::resource::vm($config, $hypervisor="qemu:///system", $allow_migrate = false, $target_host='', $ensure = present) {
  ha_crm_primitive { "vm-${name}":
    type              => "ocf:heartbeat:VirtualDomain",
#    monitor_interval  => "10s",
#    monitor_timeout   => "30s",
#    start_timeout     => "120s",
#    stop_timeout      => "120s",
    ensure            => $ensure;
  }
  
  if $ensure != absent {
    ha_crm_parameter { 
      "vm-${name}-config":
        ensure    => present,
        resource  => "vm-${name}",
        key       => "config",
        value     => $config,
        require   => Ha_Crm_Primitive["vm-${name}"];
      "vm-${name}-hypervisor":
        ensure    => present,
        resource  => "vm-${name}",
        key       => "hypervisor",
        value     => $hypervisor,
        require   => Ha_Crm_Primitive["vm-${name}"];
      "vm-${name}-allow-migrate":
        ensure    => present,
        resource  => "vm-${name}",
        meta      => true,
        key       => "allow_migrate",
        value     => $allow_migrate,
        require   => Ha_Crm_Primitive["vm-${name}"];
    }
    
    # ha_crm_order {
    #   "vm-${name}-after-initiator":
    #     ensure      => present,
    #     score       => "INFINITY",
    #     symmetrical => "false",
    #     first       => "iscsi-initiator-clone",
    #     then        => "vm-${name}",
    #     require     => [Ha_Crm_Primitive["vm-${name}"], Ha_Crm_Clone["iscsi-initiator-clone"]];
    # }
    
    if $target_host != '' {
      ha_crm_location {
        "vm-${name}-placement":
          ensure    => present,
          resource  => "vm-${name}",
          score     => "-INFINITY",
          rule      => "#uname ne ${target_host}",
          require   => Ha_Crm_Primitive["vm-${name}"];
      }
    }
  }
}

