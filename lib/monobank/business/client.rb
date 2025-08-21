require 'monobank/business/statement'
require 'monobank/business/accounts'
require 'monobank/business/account'
require 'monobank/business/statement_item'

module Monobank
  module Business
    class Client
      attr_reader :token

      def initialize(token:)
        @token = token
      end

      def statement(account:, from:, to: nil, limit: nil)
        Business::Statement.new(token:, account:, from:, to:, limit:).call
      end

      def statement_item(id:)
        Business::StatementItem.new(token: token, id: id).call
      end

      def accounts
        Business::Accounts.new(token:).call
      end

      def account(iban:)
        Business::Account.new(token: token, iban: iban).call
      end
    end
  end
end