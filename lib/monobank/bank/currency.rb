require 'monobank/endpoint'
require 'monobank/resources/bank/currency'

module Monobank
  module Bank
    class Currency < Endpoint
      ENDPOINT = '/bank/currency'.freeze

      private

      def define_resources(attributes)
        attributes.map do |attrs|
          Monobank::Resources::Bank::Currency.new(attrs)
        end
      end

      def pathname
        ENDPOINT
      end
    end
  end
end
