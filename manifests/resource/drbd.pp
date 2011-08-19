define ha::resource::drbd($ensure = present) { 
  if $ensure != absent {
    ha_crm_primitive { "${name}-drbd":
      type              => "ocf:linbit:drbd",
      ensure            => $ensure;
    }
    ha_crm_parameter { 
      "${name}-drbd-resource":
        ensure    => $ensure,
        resource  => "${name}-drbd",
        key       => "drbd_resource",
        value     => "${name}",
        require   => Ha_Crm_Primitive["${name}-drbd"];
    }
  }
  ha_crm_ms { "${name}-drbd-ms":
    ensure          => $ensure,
    resource        => "${name}-drbd",
    require         => Ha_Crm_Primitive["${name}-drbd"],
    master_max      => '1',
    master_node_max => '1',
    clone_max       => '2',
    clone_node_max  => '1',
    notify          => true;
  }
}