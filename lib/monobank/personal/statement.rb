require 'monobank/resources/personal/statement'

module Monobank
  module Personal
    class Statement
      ENDPOINT = '/personal/statement'.freeze

      def initialize(token:, account_id:, from:, to:)
        @token = token
        @account_id = account_id
        @from = from
        @to = to
      end

      def call
        attributes = connection.get(pathname, options)
        define_resources(attributes)
      end

      private

      attr_reader :token, :account_id, :from, :to

      def pathname
        path = "#{ENDPOINT}/#{account_id}/#{from}"
        path = "#{path}/#{to}" if to
        path
      end

      def options
        { headers: { "X-Token" => token.to_s } }
      end

      def connection
        @connection ||= Connection.new
      end

      def define_resources(attributes)
        attributes.map do |attrs|
          Monobank::Resources::Personal::Statement.new(attrs)
        end
      end
    end
  end
end