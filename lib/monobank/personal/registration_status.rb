require 'monobank/methods/post'
require 'monobank/resources/personal/registration_status'

module Monobank
  module Personal
    class RegistrationStatus < Methods::Post
      ENDPOINT = '/personal/auth/registration/status'.freeze

      def initialize(public_key:, **rest)
        super(**rest)

        @public_key = public_key
      end

      def pathname
        ENDPOINT
      end

      private

      attr_reader :public_key

      def body
        { pubkey: public_key }
      end

      def define_resources(attributes)
        Resources::Personal::RegistrationStatus.new(attributes)
      end
    end
  end
end
