require 'monobank/connection'
require 'monobank/bank/currency'
require 'monobank/personal/client_info'
require 'monobank/personal/statement'
require 'monobank/personal/webhook'

module Monobank
  class Client
    def bank_currency
      Bank::Currency.new.call
    end

    def client_info(token:)
      Personal::ClientInfo.new(token: token).call
    end

    def statement(token:, account_id:, from:, to: nil)
      Personal::Statement.new(token: token, account_id: account_id, from: from, to: to).call
    end

    def webhook(token:, url:)
      Personal::Webhook.new(token: token, url: url).call
    end
  end
end
