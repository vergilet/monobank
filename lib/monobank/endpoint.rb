require 'monobank/resources/error'

module Monobank
  class Endpoint
    def call
      attributes = connection.get(pathname, options)
      return define_resources(attributes) if attributes.success?

      Monobank::Resources::Error.new(attributes)
    end

    private

    attr_reader :token

    def options
      { headers: { "X-Token" => token.to_s } }
    end

    def connection
      @connection ||= Connection.new
    end
  end
end
