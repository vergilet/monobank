require 'monobank/methods/get'
require 'monobank/resources/personal/auth_check'

module Monobank
  module Personal
    class AuthCheck < Methods::Get
      ENDPOINT = '/personal/auth/request'.freeze

      private

      attr_reader :request_id

      def pathname
        ENDPOINT
      end

      def define_resources(attributes)
        Monobank::Resources::Personal::AuthCheck.new(attributes)
      end
    end
  end
end
