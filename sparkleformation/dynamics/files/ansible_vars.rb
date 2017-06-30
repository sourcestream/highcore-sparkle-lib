SparkleFormation.dynamic(:files_ansible_vars) do | id, parameters = {}, refs = {} |

  params = {
      :component_id => id
  }

  # Collect component parameters
  parameters.each do |key, parameter|
    # generate only parameters defined in template
    next unless parameter[:type]
    aws_id = parameter[:level] == 'component' ? :"#{id}_#{parameter[:id]}" : key
    if parameter[:sensitive]
      refs[key] = ref!(aws_id) if parameter[:value]
    else
      params[key] = parameter[:value] unless parameter[:value].to_s.empty?
    end
  end

  params_array = [params.to_json.chomp('}')]

  refs.each do |key, ref|
    params_array << "," unless params_array.length == 1 and params.empty?
    params_array << "\"#{key}\":\""
    params_array << ref
    params_array << "\""
  end

  params_array << "}"

  set!("/root/.ansible/#{id}.json_tmp") do
    set!(:content, join!(params_array))
    mode "000600"
  end

  set!('/usr/bin/ansible-generate-vars') do
    content join!([
                      "#!/bin/bash\n",
                      # fixing newline characters in generated json by replacing them with \n
                      "awk 1 ORS='\\\\n' < /root/.ansible/#{id}.json_tmp | sed '$s/\\\\n$//' > /root/.ansible/#{id}.json\n",
                      "python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)' < /root/.ansible/#{id}.json > /root/.ansible/#{id}.yaml",
                  ])

    mode "000755"
  end
end