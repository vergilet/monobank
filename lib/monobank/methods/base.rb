require 'monobank/resources/error'

module Monobank
  module Methods
    class Base
      def initialize(auth:)
        @auth = auth
      end

      def call
        attributes = response
        return define_resources(attributes) if attributes.code == 200

        Monobank::Resources::Error.new(attributes.merge('code' => attributes.code))
      end

      private

      attr_reader :auth

      def response
        raise NotImplementedError
      end

      def options
        {
          headers: auth.to_headers,
          body: body.to_json
        }
      end

      def body; end

      def connection
        @connection ||= Connection.new
      end
    end
  end
end
