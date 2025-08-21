require 'monobank/resources/base'

module Monobank
  module Resources
    module Business
      class Statement < Base
        define_fields %w[id time destination amount currency_code receipt_id counter_edrpou counter_iban counter_name reverse status]
      end
    end
  end
end