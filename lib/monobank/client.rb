require 'monobank/connection'
require 'monobank/bank/currency'

module Monobank
  class Client
    def bank_currency
      Bank::Currency.new.call
    end
  end
end