# frozen_string_literal: true

module Grille
  module Mutations
    module Auth
      class SignIn < Grille::Mutations::Base
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
          ::Grille::Mutations::Auth.user_to_hash(user)
        end
      end
    end
  end
end
