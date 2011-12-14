require 'rexml/document'

Puppet::Type.type(:ha_crm_colocation).provide(:crm) do

  commands :crm => "crm"

  def create
    destroy rescue true
    if resource[:resource_role]
      rsc = "#{resource[:resource]}:#{resource[:resource_role]}"
    else
      rsc = resource[:resource]
    end

    if resource[:with_resource_role]
      with_rsc = "#{resource[:with_resource]}:#{resource[:with_resource_role]}"
    else
      with_rsc = resource[:with_resource]
    end

    crm "-F", "configure", "colocation", resource[:id], "#{resource[:score]}:", rsc, with_rsc
  end

  def destroy
    crm "-F", "configure", "delete", resource[:id]
  end

  def exists?
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname))
      return resource[:ensure] == :present ? true : false
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      colocation = REXML::XPath.first(cib, "//rsc_colocation[@id='#{resource[:id]}']")
      
      colocation && (
        (!resource[:resource_role] || colocation.attribute("rsc-role").value == resource[:resource_role]) &&
        (!resource[:with_resource_role] || colocation.attribute("with-rsc-role").value == resource[:with_resource_role]) &&
        !(colocation.attribute(:rsc).value != resource[:resource] || 
          colocation.attribute("with-rsc").value != resource[:with_resource] || 
          !colocation.attribute(:score).value =~ resource[:score])
      )
    end
  end
end
