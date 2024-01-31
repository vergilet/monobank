require 'monobank/methods/post'
require 'monobank/resources/personal/auth_request'

module Monobank
  module Personal
    class AuthRequest < Methods::Post
      ENDPOINT = '/personal/auth/request'.freeze

      def initialize(callback: nil, **rest)
        super(**rest)
        @callback = callback
      end

      private

      attr_reader :callback

      def pathname
        ENDPOINT
      end

      def headers
        {'X-Callback' => callback} if callback
      end

      def define_resources(attributes)
        Monobank::Resources::Personal::AuthRequest.new(attributes)
      end
    end
  end
end
