# frozen_string_literal: true

module Mutations
  module Auth
    class SignIn < Mutations::BaseMutation
      null true

      argument :email, String, required: true
      argument :password, String, required: true

      field :result, String, null: false

      def grille_resolver(email:, password:)
        user = User.find_for_authentication(email: email)
        return nil unless user

        is_valid_for_auth = user.valid_for_authentication? do
          user.valid_password?(password)
        end

        return unless is_valid_for_auth

        context[:current_user] = user
        user.as_json.slice('email', 'id').merge('token' => user.token)
      end
    end
  end
end
