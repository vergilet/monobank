require 'forwardable'
require 'monobank/corporate/client'

module Monobank
  module Corporate
    extend SingleForwardable
    def_delegators :client, :registration, :registration_status, :set_webhook, :settings

    def self.configure(private_key:, key_id: nil)
      @private_key = private_key
      @key_id = key_id
      @client = nil
    end

    def self.client
      @client ||= Client.new(private_key: @private_key, key_id: @key_id)
    end
  end
end
