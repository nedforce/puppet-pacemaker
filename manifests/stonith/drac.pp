define ha::stonith::drac($drac_ip, $user="stonith", $password, $no_location_rule="false") {

  ha_crm_primitive { "stonith-${name}":
    type             => "stonith:external/ipmi",
    require          => Package["ipmitool"],
  }

  ha_crm_parameter {
    "stonith-${name}-hostname":
        resource  => "stonith-${name}",
        key       => "hostname",
        value     => $name,
        require   => Ha_Crm_Primitive["stonith-${name}"];
    "stonith-${name}-ipaddr":
        resource  => "stonith-${name}",
        key       => "ipaddr",
        value     => $drac_ip,
        require   => Ha_Crm_Primitive["stonith-${name}"];
    "stonith-${name}-userid":
        resource  => "stonith-${name}",
        key       => "userid",
        value     => $user,
        require   => Ha_Crm_Primitive["stonith-${name}"];
    "stonith-${name}-passwd":
        resource  => "stonith-${name}",
        key       => "passwd",
        value     => $password,
        require   => Ha_Crm_Primitive["stonith-${name}"];
  }

  ha_crm_location { 
    "stonith-${name}-not-on-${name}":
      resource  => "stonith-${name}",
      score     => "-INFINITY",
      host      => "${name}",
      require   => Ha_Crm_Primitive["stonith-${name}"],
  }
}
