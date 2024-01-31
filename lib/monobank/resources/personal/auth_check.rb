require 'monobank/resources/base'

module Monobank
  module Resources
    module Personal
      class AuthCheck < Base
        define_fields %w[status]
      end
    end
  end
end
