SparkleFormation::Registry.register(:instance_profile) do | id, config = {} |
  config[:path] ||= '/'
  dynamic!(:instance_profile, id, config)
end