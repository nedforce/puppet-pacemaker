define ha::stonith::drac($drac_ip, $user="stonith", $password, $no_location_rule="false") {

  ha_crm_primitive { "stonith-${fqdn}":
    class_name       => "stonith:external/ipmi",
    monitor_interval => "5s",
    ignore_dc        => "true",
    require          => Package["ipmitool"],
  }

  ha_crm_parameter {
    "stonith-${fqdn}-hostname":
        resource  => "stonith-${fqdn}${index}",
        parameter => "hostname",
        value     => $fqdn,
        ignore_dc => "true",
        require   => Ha_Crm_Primitive["stonith-${fqdn}"];
    "stonith-${fqdn}-ipaddr":
        resource  => "stonith-${fqdn}${index}",
        parameter => "ipaddr",
        value     => $drac_ip,
        ignore_dc => "true",
        require   => Ha_Crm_Primitive["stonith-${fqdn}"];
    "stonith-${fqdn}-userid":
        resource  => "stonith-${fqdn}${index}",
        parameter => "userid",
        value     => $user,
        ignore_dc => "true",
        require   => Ha_Crm_Primitive["stonith-${fqdn}"];
    "stonith-${fqdn}-passwd":
        resource  => "stonith-${fqdn}${index}",
        parameter => "passwd",
        value     => $password,
        ignore_dc => "true",
        require   => Ha_Crm_Primitive["stonith-${fqdn}"];
    "stonith-${fqdn}-interface":
        resource  => "stonith-${fqdn}${index}",
        parameter => "interface",
        value     => "lan",
        ignore_dc => "true",
        require   => Ha_Crm_Primitive["stonith-${fqdn}"];
  }

  ha_crm_location { "stonith-${fqdn}-not-on-${fqdn}":
    resource  => "stonith-${fqdn}",
    score     => "-inf",
    host      => $fqdn,
    ignore_dc => "true",
    require   => Ha_Crm_Primitive["stonith-${fqdn}"],
  }
}
