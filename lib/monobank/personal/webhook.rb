require 'monobank/methods/post'
require 'monobank/resources/personal/webhook'

module Monobank
  module Personal
    class Webhook < Methods::Post
      ENDPOINT = '/personal/webhook'.freeze

      def initialize(url:, **rest)
        super(**rest)

        @url = url
      end

      private

      attr_reader :url

      def pathname
        ENDPOINT
      end

      def body
        { webHookUrl: url }
      end

      def define_resources(attributes)
        Monobank::Resources::Personal::Webhook.new(attributes)
      end
    end
  end
end
