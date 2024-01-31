require 'monobank/personal/webhook'

module Monobank
  module Personal
    class CorporateWebhook < Webhook
      ENDPOINT = '/personal/corp/webhook'.freeze

      private

      def pathname
        ENDPOINT
      end
    end
  end
end
