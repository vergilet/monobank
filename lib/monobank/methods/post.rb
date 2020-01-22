require 'monobank/methods/base'
require 'monobank/resources/error'

module Monobank
  module Methods
    class Post < Base

      private

      def response
        connection.post(pathname, options)
      end
    end
  end
end
