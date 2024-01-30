require 'monobank/methods/get'
require 'monobank/resources/personal/client_info'

module Monobank
  module Personal
    class ClientInfo < Methods::Get
      ENDPOINT = '/personal/client-info'.freeze

      private

      def pathname
        ENDPOINT
      end

      def define_resources(attributes)
        Monobank::Resources::Personal::ClientInfo.new(attributes)
      end
    end
  end
end
