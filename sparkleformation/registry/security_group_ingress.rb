SparkleFormation::Registry.register(:security_group_ingress) do | id, config = {} |
  config[:ip_protocol] ||= 'tcp'
  config[:from_port] ||= config[:port]
  config[:to_port] ||= config[:port]

  dynamic!(:ec2_security_group_ingress, id,
           :group_id => config[:group_id],
           :ip_protocol => config[:ip_protocol],
           :from_port => config[:from_port],
           :to_port => config[:to_port],
           :source_security_group_id => config[:source_security_group_id] || nil,
           :cidr_ip => config[:cidr_ip] || nil
  )

end