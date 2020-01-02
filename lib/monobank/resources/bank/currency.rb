# frozen_string_literal: true

module Monobank
  module Resources
    module Bank
      class Currency < ::Monobank::Resources::Base
        private

        ENDPOINT = '/bank/currency'

        def endpoint
          ENDPOINT
        end
      end
    end
  end
end
