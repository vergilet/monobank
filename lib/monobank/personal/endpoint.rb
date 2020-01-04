require 'monobank/base_endpoint'

module Monobank
  module Personal
    class Endpoint < BaseEndpoint

      def initialize(token:)
        @token = token
      end

      private

      attr_reader :token

      def options
        { headers: { "X-Token" => token.to_s } }
      end
    end
  end
end
