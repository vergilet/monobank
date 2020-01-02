require 'monobank/connection'
require 'monobank/bank/currency'
require 'monobank/personal/client_info'

module Monobank
  class Client
    def bank_currency
      Bank::Currency.new.call
    end

    def client_info(token:)
      Personal::ClientInfo.new(token).call
    end
  end
end