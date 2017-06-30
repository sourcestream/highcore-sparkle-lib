SparkleFormation::Registry.register(:outputs) do | config = {} |
  outputs do
    config[:outputs].each do |_name, _value|
      set!(_name) do
        description "Output of #{_name}"
        value _value.is_a?(Array) ? join!('[', join!(_value, :options => {:delimiter => ','}), ']') : _value
      end
    end
  end
end