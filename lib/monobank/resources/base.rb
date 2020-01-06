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
        attributes.each { |key, value| @attributes[method_name(key)] = value }
      end

      def method_name(key)
        key.gsub(/(.)([A-Z])/,'\1_\2').downcase
      end

      attr_reader :attributes
    end
  end
end
