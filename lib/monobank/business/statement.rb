require 'monobank/methods/business/get'
require 'monobank/resources/business/statement'

require 'monobank/methods/get'
require 'monobank/resources/personal/statement'

module Monobank
  module Business
    # Correctly inherits from the business-specific Get class
    class Statement < Methods::Business::Get
      ENDPOINT = '/ext/v1/statement'.freeze

      def initialize(account:, from:, to: nil, limit: nil, **rest)
        super(**rest)
        @account = account
        @from = from
        @to = to
        @limit = limit
      end

      private

      attr_reader :account, :from, :to, :limit

      def pathname
        path = "#{ENDPOINT}/#{account}/#{from}"
        path = "#{path}/#{to}" if to
        path
      end

      def query_params
        { limit: limit }.compact
      end

      def define_resources(attributes)
        attributes.map { |attrs| Monobank::Resources::Business::Statement.new(attrs) }
      end
    end
  end
end