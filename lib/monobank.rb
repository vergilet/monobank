require 'monobank/version'
require 'monobank/client'
require 'monobank/corporate'
require 'forwardable'

module Monobank
  extend SingleForwardable
  def_delegators :client, :bank_currency, :client_info, :statement, :set_webhook

  def self.client
    @client ||= Client.new
  end

  class << self
    attr_accessor :token
  end
end
