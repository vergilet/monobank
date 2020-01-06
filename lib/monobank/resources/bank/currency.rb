require 'monobank/resources/base'

module Monobank
  module Resources
    module Bank
      class Currency < Base
        define_fields %w[currency_code_a currency_code_b date rate_sell rate_buy rate_cross]
      end
    end
  end
end
