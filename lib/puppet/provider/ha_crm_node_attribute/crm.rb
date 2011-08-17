require 'rexml/document'

Puppet::Type.type(:ha_crm_node_attribute).provide(:crm) do

  commands :crm_node_attribute => "crm node attribute"

  def create
    crm_node_attribute resource[:host], "set", resource[:attribute], resource[:value]
  end

  def destroy
    crm_node_attribute resource[:host], "del", resource[:attribute]
  end

  def exists?
    if (resource[:only_run_on_dc] == :true) and ( Facter.value(:ha_cluster_dc) != Facter.value(:fqdn) or Facter.value(:ha_cluster_dc) != Facter.value(:hostname)) 
      true
    else
      val = crm_node_attribute resource[:host], "show", resource[:name]
      val == resource[:value]
    end
  end
end
