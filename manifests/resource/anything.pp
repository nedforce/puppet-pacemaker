define ha::resource::anything(
  $binfile,
  $workdir          = "",
  $cmdline_options  = "",
  $logfile          = "",
  $errlogfile       = "",
  $user             = "root",
  $monitor_hook     = "ps -p `cat /var/run/anything_${name}.pid`",
  $monitor_interval = "60",
  $monitor_timeout  = "20",
  $monitor_on_fail  = 'restart', 
  $ensure = present) {
    ha_crm_primitive { "${name}":
      type    => "ocf:heartbeat:anything",
      ensure => $ensure;
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
        "${name}-logfile":
          ensure    => present,
          resource  => "${name}",
          key       => "logfile",
          value     => "${logfile}",
          require   => Ha_Crm_Primitive["${name}"];
        "${name}-errlogfile":
          ensure    => present,
          resource  => "${name}",
          key       => "errlogfile",
          value     => "${errlogfile}",
          require   => Ha_Crm_Primitive["${name}"];
        "${name}-monitor_hook":
          ensure    => present,
          resource  => "${name}",
          key       => "monitor_hook",
          value     => "${monitor_hook}",
          require   => Ha_Crm_Primitive["${name}"];
      }
    }
}

