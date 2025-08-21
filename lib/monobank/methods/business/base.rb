require 'monobank/methods/base'
require 'monobank/business/connection'

module Monobank
  module Methods
    module Business
      class Base < Monobank::Methods::Base
        def initialize(token:, **rest)
          super(**rest)
          @token = token
        end

        private

        attr_reader :token


        def headers
          { 'X-Token' => token, 'Accept' => 'application/json' }
        end

        def options
          {
            headers: headers,
            body: body&.to_json,
            query: query_params
          }.compact
        end

        def body; nil; end
        def query_params; {}; end
           
        def connection
          @connection ||= Monobank::Business::Connection.new
        end
      end
    end
  end
end