define ha::resource::lvm($vgname, $ensure = present) {
  ha_crm_primitive { 
    "${name}":
      type    => "ocf:heartbeat:LVM"
      ensure           => $ensure;
  }
  if $ensure != absent {
    ha_crm_parameter { "${name}-volgrpname":
      ensure    => present,
      resource  => "${name}",
      key       => "volgrpname",
      value     => '${vgname}',
      require   => Ha_Crm_Primitive["${name}"];
    }
  }
}