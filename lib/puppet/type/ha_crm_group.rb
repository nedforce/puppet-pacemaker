Puppet::Type.newtype(:ha_crm_group) do
  @doc = "Group Pacemaker resources"

  ensurable

  newparam(:id) do
    desc "The name of the resource"

    isnamevar
  end

  newparam(:resources) do
    desc "The names of the cluster resources (primitives) that will be grouped"
  end

  newparam(:only_run_on_dc, :boolean => true) do
    desc "In order to prevent race conditions, we generally only want to
          make changes to the CIB on a single machine (in this case, the
          Designated Controller)."

    newvalues(:true, :false)
    defaultto(:true)
  end
  
  validate do
    raise Puppet::Error, "You must specify the resources to be grouped" unless @parameters.include?(:resources)
  end
end
