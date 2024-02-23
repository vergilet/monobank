require 'monobank/methods/post'
require 'monobank/resources/personal/registration'

module Monobank
  module Personal
    class Registration < Methods::Post
      ENDPOINT = '/personal/auth/registration'.freeze

      def initialize(public_key:, name:, description:, contact_person:, phone:, email:, logo:, **rest)
        super(**rest)

        @public_key = public_key
        @name = name
        @description = description
        @contact_person = contact_person
        @phone = phone
        @email = email
        @logo = logo
      end

      def pathname
        ENDPOINT
      end

      private

      attr_reader :public_key, :name, :description, :contact_person, :phone, :email, :logo

      def body
        {
          pubkey: public_key,
          name:,
          description:,
          contactPerson: contact_person,
          phone:,
          email:,
          logo:
        }
      end

      def define_resources(attributes)
        Resources::Personal::Registration.new(attributes)
      end
    end
  end
end
