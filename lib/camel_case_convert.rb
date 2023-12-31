module CamelCaseConvert
  def self.convert_to_camel_case(data)
    if data.is_a?(Array)
      data.map do |item|
        convert_keys_to_camel_case(item.attributes)
      end
    else
      convert_keys_to_camel_case(data.attributes)
    end
  end

  def self.convert_keys_to_camel_case(hash)
    hash.transform_keys { |key| key.to_s.camelize(:lower).to_sym }
  end
end

module Kernel
    private
    include CamelCaseConvert 
  end