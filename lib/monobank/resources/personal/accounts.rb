require 'monobank/resources/base'

module Monobank
  module Resources
    module Personal
      class Accounts < Base
        define_fields %w[id balance credit_limit currency_code cashback_type]
      end
    end
  end
end
