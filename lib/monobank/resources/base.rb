# frozen_string_literal: true

module Monobank
  module Resources
    class Base
      def initialize(client, params = {})
        @client = client
        @params = params
      end

      def call
        client.get(endpoint)
      end

      private

      attr_reader :client, :params

      def endpoint
        raise NotImplementedError,
              'This method should be implemented in child classes'
      end
    end
  end
end
