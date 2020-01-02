# frozen_string_literal: true

module Monobank
  module Resources
    module Personal
      class Statements < ::Monobank::Resources::Base
        private

        ENDPOINT = '/personal/statement'
        SUFFIX_ATTRIBUTES = %i[account from to].freeze

        def endpoint
          endpoint_suffix.unshift(ENDPOINT).join('/')
        end

        def endpoint_suffix
          params.fetch_values(*SUFFIX_ATTRIBUTES).compact
        end
      end
    end
  end
end
