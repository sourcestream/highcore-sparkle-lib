SparkleFormation::Registry.register(:hosted_zone) do | id, config = {} |

  resources("#{id}_hosted_zone".to_sym) do
    type 'AWS::Route53::HostedZone'
    properties do
      name "#{config[:name]}."
      hosted_zone_config.comment join!("Hosted zone for stack ", _stack_name)
      set!('VPCs', _array(
          :VPCId => config[:vpc_id],
          :VPCRegion => _region
      ))
    end
  end

end