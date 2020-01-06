require 'monobank/resources/base'

module Monobank
  module Resources
    module Personal
      class Statement < Base
        define_fields %w[id time description mcc hold amount operation_amount currency_code commission_rate cashback_amount balance]
      end
    end
  end
end