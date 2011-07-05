require 'rexml/document'

Puppet::Type.type(:ha_crm_location).provide(:crm) do

  commands :crm => "crm"

  def create
    destroy rescue true
    if resource[:rule]
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
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname))
      resource[:ensure] == :present ? true : false
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      location = REXML::XPath.first(cib, "//rsc_location[@id='#{resource[:id]}']")
      rule = location.children.find_all{ |c| c.to_s =~ /^</ }.first rescue nil
      expression = rule.children.first rescue nil

      if resource[:rule]
        !location.nil? && 
        location.attribute("rsc") == resource[:resource] &&
        !rule.nil? && !expression.nil? &&
        rule.attribute("score") == resource[:score].to_s &&
        resource[:rule] == "#{expression.attribute('attribute')} #{expression.attribute('operation')} #{expression.attribute('value')}"
      else
        !location.nil? &&
        location.attribute("node") == resource[:node] &&
        location.attribute("rsc") == resource[:resource]
      end
    end
  end
end
