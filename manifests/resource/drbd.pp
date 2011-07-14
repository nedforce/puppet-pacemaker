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
    ensure    => $ensure,
    resource  => "${name}-drbd",
    require   => Ha_Crm_Primitive["${name}-drbd"],
  }
  if $ensure != absent {
    ha_crm_parameter { 
      "${name}-drbd-master-max":
        ensure    => $ensure,
        meta      => true,
        resource  => "${name}-drbd-ms",
        key       => "master-max",
        value     => '1',
        require   => Ha_Crm_Ms["${name}-drbd-ms"];
      "${name}-drbd-master-node-max":
        ensure    => $ensure,
        meta      => true,
        resource  => "${name}-drbd-ms",
        key       => "master-node-max",
        value     => '1',
        require   => Ha_Crm_Ms["${name}-drbd-ms"];
      "${name}-drbd-clone-max":
        ensure    => $ensure,
        meta      => true,
        resource  => "${name}-drbd-ms",
        key       => "clone-max",
        value     => '2',
        require   => Ha_Crm_Ms["${name}-drbd-ms"];
      "${name}-drbd-clone-node-max":
        ensure    => $ensure,
        meta      => true,
        resource  => "${name}-drbd-ms",
        key       => "clone-node-max",
        value     => '1',
        require   => Ha_Crm_Ms["${name}-drbd-ms"];
      "${name}-drbd-notify":
        ensure    => $ensure,
        meta      => true,
        resource  => "${name}-drbd-ms",
        key       => "notify",
        value     => 'true',
        require   => Ha_Crm_Ms["${name}-drbd-ms"];
    }
  }
}