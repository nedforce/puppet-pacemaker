require 'rexml/document'

Puppet::Type.type(:ha_crm_order).provide(:crm) do

  commands :crm => "crm"

  def create
    if resource[:first_action]
      first_rsc = "#{resource[:first]}:#{resource[:first_action]}"
    else
      first_rsc = resource[:first]
    end

    if resource[:then_action]
      then_rsc = "#{resource[:then]}:#{resource[:then_action]}"
    else
      then_rsc = resource[:then]
    end

    crm "-F", "configure", "order", resource[:id], "#{resource[:score]}:", first_rsc, then_rsc, "symmetrical=#{resource[:symmetrical].to_s}"
  end

  def destroy
    crm "-F", "configure", "delete", resource[:id]
  end

  def exists?
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      resource[:ensure] == :present ? true : false
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      colocation = REXML::XPath.first(cib, "//rsc_order[@id='#{resource[:id]}']")

      (resource[:first_action].blank? || colocation.attribute("first-action").value != resource[:first_action]) &&
      (resource[:then_action].blank?  || colocation.attribute("then-action").value != resource[:then_action]) &&
      colocation.attribute(:first).value != resource[:first] &&
      colocation.attribute(:then).value != resource[:then] &&
      colocation.attribute(:score).value != resource[:score]
    end
  end
end
