# Depracted. Use drac.pp version instead
define ha::stonith::ipmi($ipadrr, $user, $pass $ensure = present) {
  ha_crm_primitive {
    "stonith-${name}":
      type   => "stonith:external/ipmi",
      ensure => $ensure
  }
  
  ha_crm_parameter {
    "stonith-$name-hostname":
      ensure    => present,
      resource  => "stonith-${name}",
      key       => "hostname",
      value     => $name,
      require   => Ha_Crm_Primitive["stonith-${name}"];
    "stonith-$name-ipaddr":
      ensure    => present,
      resource  => "stonith-${name}",
      key       => "ipaddr",
      value     => $ipaddr,
      require   => Ha_Crm_Primitive["stonith-${name}"];
    "stonith-$name-user":
      ensure    => present,
      resource  => "stonith-${name}",
      key       => "user",
      value     => $user,
      require   => Ha_Crm_Primitive["stonith-${name}"];
    "stonith-$name-password":
      ensure    => present,
      resource  => "stonith-${name}",
      key       => "password",
      value     => $pass,
      require   => Ha_Crm_Primitive["stonith-${name}"];
  }
  
  ha_crm_location {
    "stonith-${name}-placement":
      ensure    => present,
      resource  => "stonith-${name}",
      score     => "-INFINITY",
      rule      => "#uname ne ${$name}",
      require   => Ha_Crm_Primitive["stonith-${name}"];
  }
}