require 'monobank/endpoint'

module Monobank
  class Personal
    class ClientInfo < Endpoint
      ENDPOINT = 'personal/client-info'.freeze

      def initialize(token)
        @token = token
      end

      def call
        connection.get("/#{ENDPOINT}", headers: headers )
      end

      private

      attr_reader :token

      def headers
        {
          "X-Token" => token.to_s
        }
      end
    end
  end
end