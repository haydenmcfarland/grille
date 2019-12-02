# frozen_string_literal: true

module Mutations
  module Auth
    class Login < Mutations::BaseMutation
      null true

      argument :email, String, required: true
      argument :password, String, required: true

      field :user, Types::Auth::UserType, null: false

      def grille_resolver(email:, password:)
        user = User.find_for_authentication(email: email)
        return nil unless user

        is_valid_for_auth = user.valid_for_authentication? do
          user.valid_password?(password)
        end

        is_valid_for_auth ? user : nil
      end
    end
  end
end
