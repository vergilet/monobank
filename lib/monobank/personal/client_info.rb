require 'monobank/personal/endpoint'

module Monobank
  module Personal
    class ClientInfo < Endpoint
      ENDPOINT = '/personal/client-info'.freeze
    end
  end
end
