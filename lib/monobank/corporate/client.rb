require 'monobank/auth/corporate'
require 'monobank/personal/registration'
require 'monobank/personal/registration_status'
require 'monobank/personal/corporate_webhook'
require 'monobank/personal/settings'

module Monobank
  module Corporate
    class Client
      def initialize(private_key:, key_id:)
        @private_key = private_key
        @key_id = key_id
      end

      def registration(public_key:, name:, description:, contact_person:, phone:, email:, logo:)
        Personal::Registration.new(public_key:, name:, description:, contact_person:, phone:, email:, logo:, auth:).call
      end

      def registration_status(public_key:)
        Personal::RegistrationStatus.new(public_key:, auth:).call
      end

      def set_webhook(url:)
        Personal::CorporateWebhook.new(url: url, auth:).call
      end

      def settings
        Personal::Settings.new(auth:).call
      end

      private

      attr_reader :private_key, :key_id

      def auth(request_id: nil)
        Auth::Corporate.new(private_key:, key_id:, request_id:)
      end
    end
  end
end
