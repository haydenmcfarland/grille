# frozen_string_literal: true

module Mutations
  module Auth
    class SignUp < Mutations::BaseMutation
      null true

      description 'Sign up for users'
      argument :email, String, required: true
      argument :password, String, required: true
      argument :firstName, String, required: true
      argument :lastName, String, required: true

      field :result, String, null: false

      def grille_resolver(email:, password:, first_name:, last_name:)
        user = User.create!(
          email: email,
          password: password,
          first_name: first_name,
          last_name: last_name
        )

        context[:current_user] = user
        user.as_json.slice('email', 'id').merge('token' => user.token)
      end
    end
  end
end
