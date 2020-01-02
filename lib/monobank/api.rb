# frozen_string_literal: true

module Monobank
  class Api
    def initialize(client)
      @client = client
    end

    def bank_currency
      Resources::Bank::Currency.new(client).call
    end

    def client_info
      Resources::Personal::ClientInfo.new(client).call
    end

    def statements(account:, from:, to: nil)
      params = { account: account, from: from, to: to }

      Resources::Personal::Statements.new(client, params).call
    end

    private

    attr_reader :client
  end
end
