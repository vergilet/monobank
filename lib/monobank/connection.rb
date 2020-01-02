require 'httparty'

module Monobank
  class Connection
    include HTTParty
    base_uri 'api.monobank.ua'

    def get(pathname, options = {})
      self.class.get(pathname, options)
    end
  end
end