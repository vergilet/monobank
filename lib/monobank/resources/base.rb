module Monobank
  module Resources
    class Base
      def self.define_fields(attributes)
        attributes.each do |attribute|
          define_method(attribute) { instance_variable_get("@attributes")[attribute] }
        end
      end

      def initialize(attributes)
        @attributes = {}
        snake_case_attributes = deep_snake_case(attributes)
        snake_case_attributes.each { |key, value| @attributes[method_name(key)] = value }
      end

      def method_name(key)
        key.gsub(/(.)([A-Z])/,'\1_\2').downcase
      end

      def deep_snake_case(hash)
        return hash unless hash.is_a?(Array) || hash.is_a?(Hash)

        hash.each_with_object({}) do |(key, value), object|
          object[method_name(key)] =
            if value.is_a? Hash
              deep_snake_case(value)
            elsif value.is_a? Array
              value.map { |element| deep_snake_case(element) }
            else
              value
            end
        end
      end

      attr_reader :attributes
    end
  end
end
