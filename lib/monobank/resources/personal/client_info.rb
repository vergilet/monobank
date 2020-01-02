# frozen_string_literal: true

module Monobank
  module Resources
    module Personal
      class ClientInfo < ::Monobank::Resources::Base
        private

        ENDPOINT = '/personal/client-info'

        def endpoint
          ENDPOINT
        end
      end
    end
  end
end
