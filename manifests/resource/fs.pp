define ha::resource::lvm($device, $fstype = 'ext3', $directory = "/mnt/${name}", $options = 'defaults' $ensure = present) {
  ha_crm_primitive {
    "${name}": 
      type    => "ocf:heartbeat:Filesystem"
      ensure  => present;
  }
  ha_crm_parameter { 
    "${name}-device":
      ensure    => present,
      resource  => "${name}",
      key       => "device",
      value     => "${device}",
      require   => Ha_Crm_Primitive["${name}"];
    "${name}-type":
      ensure    => present,
      resource  => "${name}",
      key       => "fstype",
      value     => "${fstype}",
      require   => Ha_Crm_Primitive["${name}"];
    "${name}-directory":
      ensure    => present,
      resource  => "${name}",
      key       => "directory",
      value     => "${directory}",
      require   => Ha_Crm_Primitive["${name}"];
    "${name}-options":
      ensure    => present,
      resource  => "${name}",
      key       => "options",
      value     => "${options}",
      require   => Ha_Crm_Primitive["${name}"];
  }