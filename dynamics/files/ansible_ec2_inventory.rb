SparkleFormation.dynamic(:files_ansible_ec2_inventory) do | id, config = {} |

  config[:config_path] ||= '/etc/ansible/ec2.ini'
  config[:loader_path] ||= '/etc/ansible/ec2.py'
  config[:script_path] ||= '/etc/ansible/ec2_ansible.py'
  config[:script_url] ||= 'https://raw.githubusercontent.com/ansible/ansible/stable-1.9/plugins/inventory/ec2.py'
  script_name = File.basename(config[:script_path], '.py')

  set!(config[:config_path]) do
    content join!([
"[ec2]\n",
"regions = ", config[:region], "\n",
"regions_exclude =\n",
"destination_variable = public_dns_name\n",
"vpc_destination_variable = private_dns_name\n",
"route53 = False\n",
"rds = False\n",
"all_instances = False\n",
"all_rds_instances = False\n",
"cache_path = ~/.ansible/", config[:stack_name], "_cache\n",
"cache_max_age = 120\n",
"nested_groups = False\n",
"group_by_instance_id = False\n",
"group_by_region = False\n",
"group_by_availability_zone = False\n",
"group_by_ami_id = False\n",
"group_by_instance_type = False\n",
"group_by_key_pair = False\n",
"group_by_vpc_id = False\n",
"group_by_security_group = False\n",
"group_by_tag_keys = True\n",
"group_by_tag_none = False\n",
"group_by_route53_names = False\n",
"group_by_rds_engine = False\n",
"group_by_rds_parameter_group = False\n",
"instance_filters = tag:aws:cloudformation:stack-name=", config[:stack_name], "\n",
                  ])
    mode "000755"
  end

  set!(config[:loader_path]) do
    content join!([
"#!/usr/bin/env python\n",
"import os.path\n",
"if not os.path.isfile('#{config[:script_path]}'):\n",
"    import urllib\n",
"    urllib.urlretrieve('#{config[:script_url]}', '#{config[:script_path]}')\n",
"import #{script_name}"
                  ])
    mode "000755"
  end

end
