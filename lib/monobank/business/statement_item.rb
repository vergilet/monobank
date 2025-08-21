require 'monobank/methods/business/get'
require 'monobank/resources/business/statement'

module Monobank
  module Business
    class StatementItem < Methods::Business::Get
      ENDPOINT = '/ext/v1/statement'.freeze

      def initialize(id:, **rest)
        super(**rest)
        @id = id
      end

      private

      attr_reader :id

      def pathname
        ENDPOINT
      end

      def query_params
        { id: id }
      end

      def define_resources(attributes)
        # The API returns a single object, not an array
        Monobank::Resources::Business::Statement.new(attributes)
      end
    end
  end
end