require 'monobank/resources/base'
require 'monobank/resources/personal/accounts'

module Monobank
  module Resources
    module Personal
      class ClientInfo < Base
        define_fields %w[name web_hook_url accounts]

        def accounts
          @attributes['accounts'].map do |account|
            Monobank::Resources::Personal::Accounts.new(account)
          end
        end
      end
    end
  end
end
