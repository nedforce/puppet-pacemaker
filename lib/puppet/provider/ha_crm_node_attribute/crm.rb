Puppet::Type.type(:ha_crm_node_attribute).provide(:crm) do

  commands :crm => "crm"

  def create
    crm "node", "attribute", resource[:host], "set", resource[:attribute], resource[:value]
  end

  def destroy
    crm "node", "attribute", resource[:host], "del", resource[:attribute]
  end

  def exists?
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      true
    else
      val = crm "node", "attribute", resource[:host], "show", resource[:name] rescue nil
      val == resource[:value]
    end
  end
end
