require 'monobank/methods/business/base'

module Monobank
  module Methods
    module Business
      class Get < Base
        private
        def response
          connection.get(pathname, options)
        end
      end
    end
  end
end