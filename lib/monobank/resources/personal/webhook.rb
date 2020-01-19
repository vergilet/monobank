require 'monobank/resources/base'
require 'monobank/resources/personal/accounts'

module Monobank
  module Resources
    module Personal
      class Webhook < Base
        define_fields %w[status]
      end
    end
  end
end
