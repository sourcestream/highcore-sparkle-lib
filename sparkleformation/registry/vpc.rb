SparkleFormation::Registry.register(:vpc) do | id, config = {} |

  config[:enable_dns_support] ||= true
  config[:enable_dns_hostnames] ||= true
  config[:instance_tenancy] ||= 'default'
  config[:tags] ||= {:Name => join!(_stack_name, '-', id)}

  config[:tags] = config[:tags].map { |tag, value|
    {
        :Key => tag,
        :Value => value,
    }
  }

  dynamic!(:vpc, id, config)

  dynamic!(:internet_gateway, id,
           :tags => config[:tags]
  )

  dynamic!(:vpc_gateway_attachment, id,
           :internet_gateway_id => ref!(:"#{id}_internet_gateway"),
           :vpc_id => ref!(:"#{id}_vpc"),
  )

  dynamic!(:route_table, id,
           :vpc_id => ref!(:"#{id}_vpc"),
           :tags => config[:tags]
  )

  dynamic!(:route, id,
           :route_table_id => ref!(:"#{id}_route_table"),
           :destination_cidr_block => "0.0.0.0/0",
           :gateway_id => ref!(:"#{id}_internet_gateway")
  )
end