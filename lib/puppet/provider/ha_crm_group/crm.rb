require 'rexml/document'

Puppet::Type.type(:ha_crm_group).provide(:crm) do
  desc "CRM shell support"

  commands :crm => "crm"
  commands :crm_resource => "crm_resource"

  def create
    crm "-F", "configure", "group", resource[:id], resource[:resources].expand(" ")
  end

  def destroy
    crm "-F", "configure", "delete", resource[:id]
  end

  def exists?
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      resource[:ensure] == :present ? true : false
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      resources = REXML::XPath.first(cib, "//cib/configuration/resources")
      primitive = REXML::XPath.first(resources, "//group[@id='#{resource[:id]}']")
      !primitive.nil?
    end
  end
end
