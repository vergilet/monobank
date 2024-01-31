require 'monobank/resources/base'

module Monobank
  module Resources
    module Personal
      class Registration < Base
        define_fields %w[status]
      end
    end
  end
end
