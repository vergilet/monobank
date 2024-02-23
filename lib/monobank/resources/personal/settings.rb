require 'monobank/resources/base'

module Monobank
  module Resources
    module Personal
      class Settings < Base
        define_fields %w[name permissions webhook]
      end
    end
  end
end
