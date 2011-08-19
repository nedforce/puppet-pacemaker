require 'rexml/document'

Puppet::Type.type(:ha_crm_clone).provide(:crm) do
  desc "CRM shell support"

  commands :crm => "crm"
  commands :crm_resource => "crm_resource"

  def create
    params = ["-F", "configure", "clone", resource[:id], resource[:resource]]
    params << "meta"
    [:priority, :target_role, :is_managed, :clone_max, :clone_node_max, :notify_clones, :globally_unique, :ordered, :interleave].each do |attr|
      attr_name = (attr == :notify_clones) ? "notify" : attr.to_s
      params << "#{attr_name}=#{resource[attr]}" if resource[attr] != "absent"
    end
    crm *params
  end

  def destroy
    crm "resource", "stop", resource[:id]
    crm "-F", "configure", "delete", resource[:id]
  end

  def exists?
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      resource[:ensure] == :present ? true : false
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      resources = REXML::XPath.first(cib, "//cib/configuration/resources")
      primitive = REXML::XPath.first(resources, "//clone[@id='#{resource[:id]}']")
      !primitive.nil?
    end
  end

  def priority
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      resource[:priority]
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      resources = REXML::XPath.first(cib, "//cib/configuration/resources")
      nvpair = REXML::XPath.first(resources, "//clone[@id='#{resource[:id]}']/meta_attributes/nvpair[@name='priority']")
      if nvpair.nil?
        :absent
      else
        nvpair.attribute(:value).value
      end
    end
  end

  def priority=(value)
    if value == :absent
      crm_resource "-m", "-r", resource[:id], "-d", "priority"
    else
      crm_resource "-m", "-r", resource[:id], "-p", "priority", "-v", value
    end
  end

  def target_role
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      resource[:target_role]
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      resources = REXML::XPath.first(cib, "//cib/configuration/resources")
      nvpair = REXML::XPath.first(resources, "//clone[@id='#{resource[:id]}']/meta_attributes/nvpair[@name='target-role']")
      if nvpair.nil?
        :absent
      else
        nvpair.attribute(:value).value
      end
    end
  end

  def target_role=(value)
    if value == :absent
      crm_resource "-m", "-r", resource[:id], "-d", "target-role"
    else
      crm_resource "-m", "-r", resource[:id], "-p", "target-role", "-v", value.to_s.capitalize
    end
  end

  def is_managed
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      resource[:is_managed]
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      resources = REXML::XPath.first(cib, "//cib/configuration/resources")
      nvpair = REXML::XPath.first(resources, "//clone[@id='#{resource[:id]}']/meta_attributes/nvpair[@name='is-managed']")
      if nvpair.nil?
        :absent
      else
        nvpair.attribute(:value).value
      end
    end
  end

  def is_managed=(value)
    if value == :absent
      crm_resource "-m", "-r", resource[:id], "-d", "is-managed"
    else
      crm_resource "-m", "-r", resource[:id], "-p", "is-managed", "-v", value.to_s
    end
  end

  def clone_max
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      resource[:clone_max]
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      resources = REXML::XPath.first(cib, "//cib/configuration/resources")
      nvpair = REXML::XPath.first(resources, "//clone[@id='#{resource[:id]}']/meta_attributes/nvpair[@name='clone-max']")
      if nvpair.nil?
        :absent
      else
        nvpair.attribute(:value).value
      end
    end
  end

  def clone_max=(value)
    if value == :absent
      crm_resource "-m", "-r", resource[:id], "-d", "clone-max"
    else
      crm_resource "-m", "-r", resource[:id], "-p", "clone-max", "-v", value.to_s
    end
  end

  def clone_node_max
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname))  
      resource[:clone_node_max]
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      resources = REXML::XPath.first(cib, "//cib/configuration/resources")
      nvpair = REXML::XPath.first(resources, "//clone[@id='#{resource[:id]}']/meta_attributes/nvpair[@name='clone-node-max']")
      if nvpair.nil?
        :absent
      else
        nvpair.attribute(:value).value
      end
    end
  end

  def clone_node_max=(value)
    if value == :absent
      crm_resource "-m", "-r", resource[:id], "-d", "clone-node-max"
    else
      crm_resource "-m", "-r", resource[:id], "-p", "clone-node-max", "-v", value.to_s
    end
  end

  def notify_clones
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      resource[:notify_clones]
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      resources = REXML::XPath.first(cib, "//cib/configuration/resources")
      nvpair = REXML::XPath.first(resources, "//clone[@id='#{resource[:id]}']/meta_attributes/nvpair[@name='notify']")
      if nvpair.nil?
        :absent
      else
        nvpair.attribute(:value).value
      end
    end
  end

  def notify_clones=(value)
    if value == :absent
      crm_resource "-m", "-r", resource[:id], "-d", "notify"
    else
      crm_resource "-m", "-r", resource[:id], "-p", "notify", "-v", value.to_s
    end
  end

  def globally_unique
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      resource[:globally_unique]
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      resources = REXML::XPath.first(cib, "//cib/configuration/resources")
      nvpair = REXML::XPath.first(resources, "//clone[@id='#{resource[:id]}']/meta_attributes/nvpair[@name='globally-unique']")
      if nvpair.nil?
        :absent
      else
        nvpair.attribute(:value).value
      end
    end
  end

  def globally_unique=(value)
    if value == :absent
      crm_resource "-m", "-r", resource[:id], "-d", "globally-unique"
    else
      crm_resource "-m", "-r", resource[:id], "-p", "globally-unique", "-v", value.to_s
    end
  end

  def ordered
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      resource[:ordered]
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      resources = REXML::XPath.first(cib, "//cib/configuration/resources")
      nvpair = REXML::XPath.first(resources, "//clone[@id='#{resource[:id]}']/meta_attributes/nvpair[@name='ordered']")
      if nvpair.nil?
        :absent
      else
        nvpair.attribute(:value).value
      end
    end
  end

  def ordered=(value)
    if value == :absent
      crm_resource "-m", "-r", resource[:id], "-d", "ordered"
    else
      crm_resource "-m", "-r", resource[:id], "-p", "ordered", "-v", value.to_s
    end
  end

  def interleave
    if resource[:only_run_on_dc] && !(Facter.value(:ha_cluster_dc) == Facter.value(:fqdn) || Facter.value(:ha_cluster_dc) == Facter.value(:hostname)) 
      resource[:interleave]
    else
      cib = REXML::Document.new File.open("/var/lib/heartbeat/crm/cib.xml")
      resources = REXML::XPath.first(cib, "//cib/configuration/resources")
      nvpair = REXML::XPath.first(resources, "//clone[@id='#{resource[:id]}']/meta_attributes/nvpair[@name='interleave']")
      if nvpair.nil?
        :absent
      else
        nvpair.attribute(:value).value
      end
    end
  end

  def interleave=(value)
    if value == :absent
      crm_resource "-m", "-r", resource[:id], "-d", "interleave"
    else
      crm_resource "-m", "-r", resource[:id], "-p", "interleave", "-v", value.to_s
    end
  end
end
