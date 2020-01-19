require 'monobank/methods/base'
require 'monobank/resources/error'

module Monobank
  module Methods
    class Get < Base

      private

      def response
        connection.get(pathname, options)
      end
    end
  end
end
