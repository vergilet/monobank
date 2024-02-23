require 'monobank/connection'
require 'monobank/auth/private'
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
      Personal::ClientInfo.new(auth: auth(token:)).call
    end

    def statement(token:, account_id:, from:, to: nil)
      Personal::Statement.new(account_id:, from:, to:, auth: auth(token:)).call
    end

    def set_webhook(token:, url:)
      Personal::Webhook.new(url:, auth: auth(token:)).call
    end

    private

    def auth(token:)
      Auth::Private.new(token:)
    end
  end
end
