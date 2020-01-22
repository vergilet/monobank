require 'monobank/resources/error'

module Monobank
  module Methods
    class Base
      def call
        return define_resources(response) if response.success?

        Monobank::Resources::Error.new(response.merge('code' => response.code))
      end

      private

      attr_reader :token

      def response
        raise NotImplementedError
      end

      def options
        {
          headers: { 'X-Token' => token.to_s },
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
