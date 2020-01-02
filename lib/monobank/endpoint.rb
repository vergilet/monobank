module Monobank
  class Endpoint
    private

    def connection
      @connection ||= Connection.new
    end
  end
end
