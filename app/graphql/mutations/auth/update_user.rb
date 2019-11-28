# frozen_string_literal: true

module Mutations
  module Auth
    class UpdateUser < Mutations::BaseMutation
      field :update_user, Types::UserType, null: true do
        description 'Update user'
        argument :password, String, required: false
        argument :passwordConfirmation, String, required: false
      end

      def update_user(
        password: context[:current_user] ? context[:current_user].password : '',
        password_confirmation: context[:current_user] ? context[:current_user].password_confirmation : ''
      )
        user = context[:current_user]
        return nil unless user

        user.update!(
          password: password,
          password_confirmation: password_confirmation
        )
        user
      end
    end
  end
end
