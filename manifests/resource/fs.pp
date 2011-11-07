define ha::resource::fs($device, $fstype = 'ext3', $directory = "/mnt/${name}", $options = 'defaults', $monitor_interval = "60", $monitor_timeout = "20", $ensure = present) {
  ha_crm_primitive {
    "${name}": 
      type              => "ocf:heartbeat:Filesystem",
      require           => Service['corosync'],
      monitor_interval  => "${monitor_interval}",
      monitor_timeout   => "${monitor_timeout}",
      ensure            => $ensure;
  }
  if ( $ensure != absent ) {
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
  }
}
