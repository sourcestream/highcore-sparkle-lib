SparkleFormation::Registry.register(:instance) do |id, config={}|

  config[:tags][:Name] = join!(_stack_name, '-', id)
  if config[:depends_on]
    config[:depends_on].map! { |dependency|
      SparkleFormation.camel(dependency)
    }
  else
    config[:depends_on] = []
  end

  dynamic!(:instance, id,
           :iam_instance_profile => config[:iam_instance_profile],
           :image_id => config[:image_id],
           :instance_type => config[:instance_type],
           :key_name => config[:key_name],
           :network_interfaces => _array(
               :associate_public_ip_address => true,
               :device_index => 0,
               :delete_on_termination => true,
               :subnet_id => config[:subnet_id],
               :group_set => config[:security_group_ids],
           ),
           :tags => config[:tags].map { |tag, value|
             {
                 :Key => tag,
                 :Value => value,
             }
           },
  ) do
    registry!(:instance_user_data, "#{id}_instance")
    registry!(:instance_metadata, "#{id}_instance", config)
    depends_on config[:depends_on]
  end

end