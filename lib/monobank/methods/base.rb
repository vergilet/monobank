require 'monobank/resources/error'

module Monobank
  module Methods
    class Base
      def initialize(auth: nil)
        @auth = auth
      end

      def call
        attributes = response
        return define_resources(attributes) if attributes.code == 200

        Monobank::Resources::Error.new(attributes.merge('code' => attributes.code))
      end

      private

      attr_reader :auth

      def pathname
        raise NotImplementedError
      end

      def response
        raise NotImplementedError
      end

      def options
        {
          headers: (headers || {}).merge(auth&.to_headers(pathname:) || {}),
          body: body.to_json
        }
      end

      def headers
        {}
      end

      def body; end

      def connection
        @connection ||= Connection.new
      end
    end
  end
end
