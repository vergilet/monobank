require 'monobank/endpoint'

module Monobank
  module Bank
    class Currency < Endpoint
      ENDPOINT = 'bank/currency'.freeze

      def call
        connection.get("/#{ENDPOINT}")
      end
    end
  end
end