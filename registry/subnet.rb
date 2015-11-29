SparkleFormation::Registry.register(:subnet) do | id, config = {} |
  config[:availability_zone] ||= "Subnet #{id}"
  config[:vpc_id] ||= ref!(:vpc)
  # TODO Reuse default tags functionality
  config[:tags] ||= {:Name => join!(_stack_name, '-', id.to_s)}

  config[:tags] = config[:tags].map { |tag, value|
    {
        :Key => tag,
        :Value => value,
    }                                             }
  config[:subnet_id] ||= ref!(:"#{id}_subnet")

  subnet_properties = [
      :cidr_block,
      :availability_zone,
      :vpc_id,
      :tags,
  ]
  subnet_config = config.select { |key, value| subnet_properties.include?(key)}

  dynamic!(:subnet, id, subnet_config)

  rta_properties = [
      :route_table_id,
      :subnet_id,
  ]
  rta_config = config.select { |key, value| rta_properties.include?(key)}

  dynamic!(:subnet_route_table_association, id, rta_config)

end