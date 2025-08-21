require 'forwardable'
require 'monobank/business/client'

module Monobank
  module Business
    extend SingleForwardable
    # We will add methods here as we implement them
    def_delegators :client, :statement, :statement_item, :accounts, :account

    def self.configure(token:)
      @token = token
      @client = nil # Reset client on re-configuration
    end

    def self.client
      raise 'Monobank::Business not configured. Call Monobank::Business.configure(token:) first.' unless @token
      @client ||= Client.new(token: @token)
    end
  end
end