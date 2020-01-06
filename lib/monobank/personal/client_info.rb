require 'monobank/resources/personal/client_info'

module Monobank
  module Personal
    class ClientInfo
      ENDPOINT = '/personal/client-info'.freeze

      def initialize(token:)
        @token = token
      end

      def call
        attributes = connection.get(pathname, options)
        define_resources(attributes)
      end

      private

      attr_reader :token, :attributes

      def pathname
        self.class::ENDPOINT
      end

      def options
        { headers: { "X-Token" => token.to_s } }
      end

      def connection
        @connection ||= Connection.new
      end

      def define_resources(attributes)
        Monobank::Resources::Personal::ClientInfo.new(attributes)
      end
    end
  end
end
