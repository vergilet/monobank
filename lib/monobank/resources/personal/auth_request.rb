require 'monobank/resources/base'

module Monobank
  module Resources
    module Personal
      class AuthRequest < Base
        define_fields %w[accept_url]

        def request_id
          @attributes['token_request_id']
        end
      end
    end
  end
end
