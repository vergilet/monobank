module Monobank
  class Endpoint
    def call
      attributes = connection.get(pathname, options)
      define_resources(attributes)
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
