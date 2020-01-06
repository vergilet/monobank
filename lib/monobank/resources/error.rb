require 'monobank/resources/base'

module Monobank
  module Resources
    class Error < Base
      define_fields %w[error_description]
    end
  end
end
