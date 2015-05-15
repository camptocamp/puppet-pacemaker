# crm_support: true/nil
# Whether there is Pacemaker installed
#

if Facter.version < '2.0.0'
  Facterclass=Facter::Util::Resolution
else
  Facterclass=Facter::Core::Execution
end

Facter.add('crm_support') do
  confine :kernel => :linux

  setcode do
    not Facterclass.which('crm_resource').nil?
  end
end

if Facter.value(:crm_support) == true
  crm_resources = Facterclass.exec('crm_resource -l').split

  Facter.add('crm_raw_resources') do
    confine :false => crm_resources.empty?
    setcode { crm_resources.join(',') }
  end
  
  crm_resources.each do |resource|
    command = "crm_resource --resource #{resource} --locate"
    crm_output = Facterclass.exec(command)
    location = /^resource #{resource} is running on: (.+?)\s?\w*$/.match(crm_output).nil? ? '' : Regexp.last_match[1]
    next if location.empty?

    if resource =~ /^\w+:(0|1)$/ # Master/Slave resources
      _resource = resource.split(':')[0]
      if crm_output =~ /^.*\sMaster$/
        fact_name = "crm_#{_resource}_master"
      else
        fact_name = "crm_#{_resource}_slave"
      end
    else
      fact_name = "crm_#{resource}"
    end

    Facter.add(fact_name) do
      setcode { location }
    end
  end

end
