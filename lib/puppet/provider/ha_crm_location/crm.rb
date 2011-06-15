require 'rexml/document'

Puppet::Type.type(:ha_crm_location).provide(:crm) do

  commands :crm => "crm"

  def create
    if resource[:rules]
      loc = "rule #{resource[:score]}: #{resource[:rule]}"
    else
      loc = "#{resource[:score]}: #{resource[:node]}"
    end

    crm "-F", "configure", "location", resource[:id], resource[:resource], loc
  end

  def destroy
    crm "-F", "configure", "delete", resource[:id]
  end

  def exists?
    if resource[:only_run_on_dc] and ( Facter.value(:ha_cluster_dc) != Facter.value(:fqdn) or Facter.value(:ha_cluster_dc) != Facter.value(:hostname)) 
      resource[:ensure] == :present ? true : false
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      location = REXML::XPath.first(cib, "//rsc_location[@id='#{resource[:id]}']")
      rule = location.children.first
      
      if resource[:rule]
        location.present? && 
        location.attribute("rsc") == resource[:resource] &&
        rule.present? && 
        rule.attribute("score") == resource[:score]
        resource[:rule] == "#{rule.children.first.attribute('attribute')} #{rule.children.first.attribute('operation')} #{rule.children.first.attribute('value')}"
      else
        location.present? &&
        location.attribute("node") == resource[:node] &&
        location.attribute("rsc") == resource[:resource]
    end
  end
end
