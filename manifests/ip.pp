# Note that setting stickiness by default to 1000 will ensure that failback does NOT happen by default - set this to a lower value if this is the desired behaviour
define ha::ip($address, $stickiness="1000", $ensure = present) {
	ha::crm::primitive { "ha-ip-${address}":
		resource_type    => "ocf:heartbeat:IPaddr2",
		monitor_interval => "10s",
		ensure           => $ensure,
		resource_stickiness => $stickiness,
	}
	
	if $ensure != absent {
		ha::crm::parameter { "ha-ip-${address}-ip":
			resource  => "ha-ip-${address}",
			parameter => "ip",
			value     => $address,
			require   => Ha::Crm::Primitive["ha-ip-${address}"],
		}
	}
}

