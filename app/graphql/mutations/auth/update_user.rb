# frozen_string_literal: true

module Mutations
  module Auth
    class UpdateUser < Mutations::BaseMutation
      null true

      description 'Update user'
      argument :password, String, required: false
      argument :passwordConfirmation, String, required: false

      type Types::Auth::UserType

      def resolve(
        password: context[:current_user] ? context[:current_user].password : '',
        password_confirmation: context[:current_user] ? context[:current_user].password_confirmation : ''
      )
        user = context[:current_user]
        return unless user

        user.update!(
          password: password,
          password_confirmation: password_confirmation
        )
        user
      end
    end
  end
end
