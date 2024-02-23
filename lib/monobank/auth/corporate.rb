module Monobank
  module Auth
    class Corporate
      def initialize(private_key:, key_id: nil, request_id: nil)
        @private_key = init_key(private_key:)
        @key_id = key_id
        @request_id = request_id
      end

      def to_headers(pathname:)
        time = Time.now.to_i

        {
          'X-Time' => time.to_s,
          'X-Sign' => Base64.strict_encode64(sign(pathname:, time:))
        }.tap do |headers|
          headers['X-Key-Id'] = key_id unless key_id.nil?
          headers['X-Request-Id'] = request_id unless request_id.nil?
        end
      end

      private

      attr_accessor :private_key, :key_id, :request_id

      def init_key(private_key:)
        OpenSSL::PKey::EC.new(private_key)
      end

      def sign(pathname:, time:)
        private_key.sign(OpenSSL::Digest::SHA256.new, "#{time}#{request_id}#{pathname}")
      end
    end
  end
end
