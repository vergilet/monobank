require 'monobank/resources/bank/currency'

module Monobank
  module Bank
    class Currency
      ENDPOINT = '/bank/currency'.freeze

      def call
        attributes = connection.get(pathname, options)
        define_resources(attributes)
      end


      def define_resources(attributes)
        attributes.map do |attrs|
          Monobank::Resources::Bank::Currency.new(attrs)
        end
      end

      def pathname
        ENDPOINT
      end

      def options
        {}
      end

      def connection
        @connection ||= Connection.new
      end
    end
  end
end
