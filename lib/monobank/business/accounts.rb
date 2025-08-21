require 'monobank/methods/business/get'
require 'monobank/resources/business/account'

module Monobank
  module Business
    class Accounts < Methods::Business::Get
      ENDPOINT = '/ext/v1/accounts'.freeze

      private

      def pathname
        ENDPOINT
      end

      def define_resources(attributes)
        attributes.map { |attrs| Monobank::Resources::Business::Account.new(attrs) }
      end
    end
  end
end