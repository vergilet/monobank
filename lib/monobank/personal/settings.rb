require 'monobank/methods/post'
require 'monobank/resources/personal/settings'

module Monobank
  module Personal
    class Settings < Methods::Post
      ENDPOINT = '/personal/corp/settings'.freeze

      def pathname
        ENDPOINT
      end

      private

      def define_resources(attributes)
        Resources::Personal::Settings.new(attributes)
      end
    end
  end
end
