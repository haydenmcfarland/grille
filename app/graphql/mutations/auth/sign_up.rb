# frozen_string_literal: true

module Mutations
  module Auth
    class SignUp < Mutations::BaseMutation
      field :sign_up, Types::UserType, null: true do
        description 'Sign up for users'
        argument :email, String, required: true
        argument :password, String, required: true
        argument :passwordConfirmation, String, required: true
        argument :firstName, String, required: true
        argument :lastName, String, required: true
      end

      def sign_up(email:, password:, password_confirmation:, first_name:, last_name:)
        User.create(
          email: email,
          password: password,
          password_confirmation: password_confirmation,
          first_name: first_name,
          last_name: last_name
        )
      end
    end
  end
end
