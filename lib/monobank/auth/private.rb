module Monobank
  module Auth
    class Private
      def initialize(token:)
        @token = token
      end

      def to_headers(*)
        { 'X-Token' => token }
      end

      private

      attr_reader :token
    end
  end
end
