Puppet::Type.type(:ha_crm_node_attribute).provide(:crm) do

  commands :crm => "crm"

  def create
    crm "node", "attribute", source[:host], "set", resource[:attribute], resource[:value]
  end

  def destroy
    crm "node", "attribute", resource[:host], "del", resource[:attribute]
  end

  def exists?
    if (resource[:only_run_on_dc] == :true) and ( Facter.value(:ha_cluster_dc) != Facter.value(:fqdn) or Facter.value(:ha_cluster_dc) != Facter.value(:hostname)) 
      true
    else
      val = crm "node", "attribute", resource[:host], "show", resource[:name]
      val == resource[:value]
    end
  end
end
