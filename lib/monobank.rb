require 'monobank/version'
require 'monobank/client'
require 'forwardable'

module Monobank
  extend SingleForwardable
  def_delegators :client, :bank_currency, :client_info, :statement

  def self.client
    @client ||= Client.new
  end

  class << self
    attr_accessor :token
  end
end
