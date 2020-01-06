require 'monobank/resources/personal/accounts'

module Monobank
  module Resources
    module Personal
      class ClientInfo
        def initialize(attributes)
          @attributes = {}
          attributes.each do |key, value|
            method_name = method_name(key)
            @attributes[method_name] = value
            next if value.is_a? Array
            self.class.define_method(method_name) { value }
          end
        end

        def accounts
          @attributes['accounts'].map do |account|
            Monobank::Resources::Personal::Accounts.new(account)
          end
        end

        def method_name(key)
          key.gsub(/(.)([A-Z])/,'\1_\2').downcase
        end
      end
    end
  end
end
