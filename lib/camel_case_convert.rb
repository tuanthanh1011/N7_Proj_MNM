module CamelCaseConvert
    def convert_to_camel_case(data)
        data.map do |item|
          convert_keys_to_camel_case(item.attributes)
        end
      end
    
      def convert_keys_to_camel_case(hash)
        hash.transform_keys { |key| key.to_s.camelize(:lower).to_sym }
      end
end