module Monobank
  class BaseEndpoint

    def call
      connection.get(pathname, options = {})
    end

    private

    def pathname
      self.class::ENDPOINT
    end

    def options; end

    def connection
      @connection ||= Connection.new
    end
  end
end
