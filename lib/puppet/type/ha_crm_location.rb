Puppet::Type.newtype(:ha_crm_location) do
  @desc = "Manages Pacemaker resource location constraints."

  ensurable

  newparam(:id) do
    desc "A unique name for the order constraint"

    isnamevar
  end

  newparam(:resource) do
    desc "A resource name"
  end

  newparam(:host) do
    desc "A host's uname"
  end

  newparam(:score) do
    desc "Positive values indicate the resource CAN run on this host.
          Negative values indicate the resource CAN NOT run on this host.
          Values of +/i infinity (inf) change CAN to MUST."
    newvalues('INFINITY', '-INFINITY', /-?\d+/)
    defaultto('INFINITY')
  end

  newparam(:rule) do
    desc "An optional rule string to suppliment the basic location constraint"
  end

  newparam(:only_run_on_dc, :boolean => true) do
    desc "In order to prevent race conditions, we generally only want to
          make changes to the CIB on a single machine (in this case, the
          Designated Controller)."

    newvalues(:true, :false)
    defaultto(:true)
  end

  validate do
    raise Puppet::Error, "You must specify a resource" unless @parameters.include?(:resource)
    raise Puppet::Error, "You must specify a score" unless @parameters.include?(:score)
    if @parameters.include?(:host) and @parameters.include?(:rule)
      raise Puppet::Error, "You must specify either a host or a rule, not both."
    end

    if !@parameters.include?(:host) and !@parameters.include?(:rule)
      raise Puppet::Error, "You must specify either a host or a rule"
    end
  end
end
