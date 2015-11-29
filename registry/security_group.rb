SparkleFormation::Registry.register(:security_group) do | id, config = {} |
  if config[:rules]
    config[:rules].map! {|rule|
      rule[:ip_protocol] ||= 'tcp'
      rule[:from_port] ||= rule[:port]
      rule[:to_port] ||= rule[:port]
      rule.delete(:port)
      rule
    }
  end

  dynamic!(:security_group, id,
      :group_description => "#{id} security group",
      :security_group_ingress => config[:rules] ? _array(*config[:rules]) : nil,
      :vpc_id => config[:vpc_id] || ref!(:vpc_id)
  )
end