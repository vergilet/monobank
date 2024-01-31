require 'monobank/resources/base'

module Monobank
  module Resources
    module Personal
      class RegistrationStatus < Base
        define_fields %w[key_id status]
      end
    end
  end
end
