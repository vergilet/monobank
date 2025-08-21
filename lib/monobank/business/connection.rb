require 'httparty'

module Monobank
  module Business
    class Connection
      include HTTParty
      base_uri 'https://corp-api.monobank.ua'

      def get(pathname, options = {})
        self.class.get(pathname, options)
      end

      def post(pathname, options = {})
        self.class.post(pathname, options)
      end
    end
  end
end