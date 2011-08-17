Puppet::Type.newtype(:ha_crm_node_attribute) do
  @desc = "Set node attribute"

  ensurable

  newparam(:name) do
    desc "Name"

    isnamevar
  end

  newparam(:attribute) do
    desc "The attribute to set"
  end

  newparam(:value) do
    desc "The value of the attribute"
  end

  newparam(:host) do
    desc "The node to set the attribute on"
  end

  newparam(:only_run_on_dc, :boolean => true) do
    desc "In order to prevent race conditions, we generally only want to
          make changes to the CIB on a single machine (in this case, the
          Designated Controller)."

    newvalues(:true, :false)
    defaultto(:true)
  end
end
