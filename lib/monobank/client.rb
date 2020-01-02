# frozen_string_literal: true

require 'httparty'

module Monobank
  class Client
    include HTTParty
    base_uri 'api.monobank.ua'

    def initialize(token = nil)
      @token = token
    end

    def get(endpoint)
      self.class.get(endpoint, request_options)
    end

    private

    attr_reader :token

    def request_options
      return {} if token.nil?

      {
        headers: {
          'X-Token' => token.to_s
        }
      }
    end
  end
end
