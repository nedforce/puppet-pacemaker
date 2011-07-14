define ha::stonith::drac($drac_ip, $user="stonith", $pass, $no_location_rule="false", $cloned="false") {
  if($cloned == "true") {
    $index = ":0"
  } else {
    $index = ""
  }

  package { "OpenIPMI-tools":
    ensure => installed;
  }

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
        "stonith-${fqdn}-user":
            resource  => "stonith-${fqdn}${index}",
            parameter => "userid", #Shouldn't this be user?
            value     => $user,
            ignore_dc => "true",
            require   => Ha_Crm_Primitive["stonith-${fqdn}"];
        "stonith-${fqdn}-passwd":
            resource  => "stonith-${fqdn}${index}",
            parameter => "passwd",
            value     => $pass,
            ignore_dc => "true",
            require   => Ha_Crm_Primitive["stonith-${fqdn}"];
        "stonith-${fqdn}-interface":
            resource  => "stonith-${fqdn}${index}",
            parameter => "interface",
            value     => "lan",
            ignore_dc => "true",
            require   => Ha_Crm_Primitive["stonith-${fqdn}"];
    }

  if($cloned == "true") {
    ha_crm_location { "clone-stonith-${fqdn}-not-on-${fqdn}":
      resource  => "clone-stonith-${fqdn}",
      score     => "-inf",
      host      => $fqdn,
      ignore_dc => "true",
      require   => Ha_Crm_Primitive["stonith-${fqdn}"],
    }
  } else {    
    ha_crm_location { "stonith-${fqdn}-not-on-${fqdn}":
      resource  => "stonith-${fqdn}",
      score     => "-inf",
      host      => $fqdn,
      ignore_dc => "true",
      require   => Ha_Crm_Primitive["stonith-${fqdn}"],
    }
  }
}
