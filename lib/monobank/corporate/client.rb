require 'monobank/auth/corporate'
require 'monobank/personal/registration'
require 'monobank/personal/registration_status'
require 'monobank/personal/corporate_webhook'
require 'monobank/personal/settings'
require 'monobank/personal/auth_request'
require 'monobank/personal/auth_check'
require 'monobank/personal/client_info'
require 'monobank/personal/statement'

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

      def auth_request(callback: nil)
        Personal::AuthRequest.new(callback:, auth:).call
      end

      def auth_check(request_id:)
        Personal::AuthCheck.new(auth: auth(request_id:)).call
      end

      def client_info(request_id:)
        Personal::ClientInfo.new(auth: auth(request_id:)).call
      end

      def statement(request_id:, account_id:, from:, to: nil)
        Personal::Statement.new(account_id:, from:, to:, auth: auth(request_id:)).call
      end

      private

      attr_reader :private_key, :key_id

      def auth(request_id: nil)
        Auth::Corporate.new(private_key:, key_id:, request_id:)
      end
    end
  end
end
