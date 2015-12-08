SparkleFormation::Registry.register(:parameters) do | config = {} |
  # Convert script parameters into CF parameters
  def to_aws_parameters(component_id, parameters, compiled_template)
    aws_params = {}
    parameters.each do | id, parameter|
      aws_id = parameter[:level] == 'component' ? :"#{component_id}_#{parameter[:id]}" : id
      next unless compiled_template.include? ('{"Ref":"' + SparkleFormation.camel(aws_id) + '"}') or
        (parameter[:sensitive] and parameter[:value] and parameter[:type])
      aws_parameter = parameter.clone
      aws_parameter[:type] = aws_parameter[:aws_type] if aws_parameter[:aws_type]

      if aws_parameter[:value]
        aws_parameter[:default] = aws_parameter[:value]
      else
        aws_parameter.delete(:default)
      end

      case aws_parameter[:type]
        when 'array'
          aws_parameter[:type] = 'CommaDelimitedList'
          aws_parameter[:default] = aws_parameter[:value].join(', ') if aws_parameter[:value]
        when 'json'
          aws_parameter[:type] = 'String'
          aws_parameter[:default] = aws_parameter[:value].to_json if aws_parameter[:value]
        when 'string'
          aws_parameter[:type] = 'String'
        when 'int'
          aws_parameter[:type] = 'Number'
        when 'bool'
          aws_parameter[:type] = 'String'
        else
      end

      if aws_parameter[:sensitive]
        aws_parameter[:no_echo] = true
        aws_parameter.delete(:default)
      end

      parameter_properties = [
          :type,
          :default,
          :no_echo,
          :allowed_values,
          :allowed_pattern,
          :max_length,
          :min_length,
          :max_value,
          :min_value,
          :description,
          :constraint_description,
      ]
      aws_parameter = aws_parameter.select { |key, value| parameter_properties.include?(key.to_sym)}
      aws_params[aws_id] = aws_parameter
    end
    aws_params
  end

  aws_params = {}
  config[:components].each { | id, component |
    aws_params.merge!(to_aws_parameters(id, component[:parameters], config[:compiled_template])) {|k, x, y| x.merge(y)}
  }

  set!(:parameters, aws_params)

end