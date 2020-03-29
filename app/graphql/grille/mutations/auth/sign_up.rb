# frozen_string_literal: true

module Grille
  module Mutations
    module Auth
      class SignUp < Grille::Mutations::Base
        description 'Sign up for users'
        argument :email, String, required: true
        argument :password, String, required: true
        argument :firstName, String, required: true
        argument :lastName, String, required: true

        field :result, String, null: false

        def grille_resolver(email:, password:, first_name:, last_name:)
          user = ::Grille::User.create!(
            email: email,
            password: password,
            first_name: first_name,
            last_name: last_name
          )

          context[:current_user] = user
          ::Grille::Mutations::Auth.user_to_hash(user)
        end
      end
    end
  end
end
