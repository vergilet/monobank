module Monobank
  module Resources
    module Personal
      class Statement

        def initialize(attributes)
          @attributes = {}
          attributes.each do |key, value|
            @attributes[method_name(key)] = value
            self.class.define_method(method_name(key)) { value }
          end
        end

        def method_name(key)
          key.gsub(/(.)([A-Z])/,'\1_\2').downcase
        end
      end
    end
  end
end