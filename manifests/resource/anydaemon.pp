define ha::resource::anydaemon(
  $binfile,
  $workdir          = "",
  $cmdline_options  = "",
  $pidfile          = "/tmp/anydaemon_${name}.pid",
  $user             = "root",
  $monitor_hook     = "ps -p `cat ${pidfile}`",
  $monitor_interval = "60",
  $monitor_timeout  = "20",
  $monitor_on_fail  = 'restart', 
  $stop_command     = "",
  $ensure = present) {
    ha_crm_primitive { "${name}":
      type             => "ocf:heartbeat:anydaemon",
      ensure           => $ensure;
      monitor_interval => "${monitor_interval}",
      monitor_timeout  => "${monitor_timeout}",
      monitor_on_fail  => "${monitor_on_fail}",
    }
    
    if ( $ensure != absent ) {
      ha_crm_parameter { 
        "${name}-binfile":
          ensure    => present,
          resource  => "${name}",
          key       => "binfile",
          value     => "${binfile}",
          require   => Ha_Crm_Primitive["${name}"];
        "${name}-workdir":
          ensure    => present,
          resource  => "${name}",
          key       => "workdir",
          value     => "${workdir}",
          require   => Ha_Crm_Primitive["${name}"];
        "${name}-cmdline_options":
          ensure    => present,
          resource  => "${name}",
          key       => "cmdline_options",
          value     => "${cmdline_options}",
          require   => Ha_Crm_Primitive["${name}"];
        "${name}-user":
          ensure    => present,
          resource  => "${name}",
          key       => "user",
          value     => "${user}",
          require   => Ha_Crm_Primitive["${name}"];
        "${name}-pidfile":
          ensure    => present,
          resource  => "${name}",
          key       => "pidfile",
          value     => "${pidfile}",
          require   => Ha_Crm_Primitive["${name}"];
        "${name}-monitor_hook":
          ensure    => present,
          resource  => "${name}",
          key       => "monitor_hook",
          value     => "${monitor_hook}",
          require   => Ha_Crm_Primitive["${name}"];
        "${name}-stop_command":
          ensure    => present,
          resource  => "${name}",
          key       => "stop_command",
          value     => "${stop_command}",
          require   => Ha_Crm_Primitive["${name}"];
      }
    }
}

