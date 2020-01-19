require 'monobank/resources/error'

module Monobank
  module Methods
    class Base
      def call
        attributes = response.parsed_response
        return define_resources(attributes) if attributes.success?

        Monobank::Resources::Error.new(attributes.merge('code' => attributes.code))
      end

      private

      attr_reader :token

      def response
        raise NotImplementedError
      end

      def options
        {
          headers: { "X-Token" => token.to_s },
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
