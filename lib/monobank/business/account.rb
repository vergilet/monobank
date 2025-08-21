require 'monobank/methods/business/get'
require 'monobank/resources/business/account'

module Monobank
  module Business
    class Account < Methods::Business::Get
      ENDPOINT = '/ext/v1/accounts'.freeze

      def initialize(iban:, **rest)
        super(**rest)
        @iban = iban
      end

      private

      attr_reader :iban

      def pathname
        "#{ENDPOINT}/#{iban}"
      end

      def define_resources(attributes)
        # The API returns a single object, not an array
        Monobank::Resources::Business::Account.new(attributes)
      end
    end
  end
end