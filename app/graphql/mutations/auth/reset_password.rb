# frozen_string_literal: true

module Mutations
  module Auth
    class ResetPassword < Mutations::BaseMutation
      field :reset_password, Boolean, null: true do
        argument :password, String, required: true
        argument :passwordConfirmation, String, required: true
        argument :resetPasswordToken, String, required: true
      end

      def reset_password(password:, password_confirmation:, reset_password_token:)
        user = User.with_reset_password_token(reset_password_token)
        return false unless user

        user.reset_password(password, password_confirmation)
      end
    end
  end
end
