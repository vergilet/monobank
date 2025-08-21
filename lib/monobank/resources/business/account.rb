require 'monobank/resources/base'

module Monobank
  module Resources
    module Business
      class Account < Base
        define_fields %w[iban currency balance]
      end
    end
  end
end