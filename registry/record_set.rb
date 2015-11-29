SparkleFormation::Registry.register(:record_set) do | id, config = {} |

    config[:comment] = "DNS name for instance #{id}"
    config[:type] = config[:type] || 'A'
    if config[:hosted_zone_name]
      config[:hosted_zone_name] = join!([config[:hosted_zone_name], '.'])
    end
    if config[:alias]
      config[:alias_target] = config[:target]
    else
      config[:'TTL'] = config[:ttl] || 300
      config[:resource_records] = [config[:target]]
    end
    config.delete(:zone)
    config.delete(:alias)
    config.delete(:target)

    dynamic!(:record_set, :"#{id}_#{config[:zone]}", config)

  end
