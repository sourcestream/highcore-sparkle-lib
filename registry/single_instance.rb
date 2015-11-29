SparkleFormation::Registry.register(:single_instance) do | id, config = {} |

  config[:files] ||= []
  config[:security_groups] ||= []
  config[:security_groups] << ref!(:"#{id}_security_group")
  config[:tags] ||= {}
  config[:tags][:role] ||= config[:role]

  registry!(:security_group, id)

  registry!(:instance, id,
           :image_id => config[:image_id] || map!(:region_map, 'AWS::Region', map!(:instance_type_map, :"#{id}_instance_type", :Arch)),
           :instance_type => ref!(:"#{id}_instance_type"),
           :iam_instance_profile => ref!(:instance_profile),
           :key_name => ref!(:key_name),
           :subnet_id => select!(1, ref!(:subnet_ids)),
           :files => config[:files],
           :packages => config[:packages],
           :commands => config[:commands],
           :security_group_ids => config[:security_groups],
           :tags => config[:tags],
           :playbooks => config[:playbooks] || nil,
           :depends_on => config[:depends_on] || nil
  )

  if config[:private_zone_name] and config[:private_zone_id]
    registry!(:record_set, id,
             :name => join!("#{id}-", _stack_name, ".", config[:private_zone_name]),
             :target => attr!("#{id}_instance".to_sym, :private_ip),
             :hosted_zone_id => config[:private_zone_id]
    )
  end
end
