require 'monobank/base_endpoint'

module Monobank
  module Bank
    class Currency < BaseEndpoint
      ENDPOINT = '/bank/currency'.freeze
    end
  end
end