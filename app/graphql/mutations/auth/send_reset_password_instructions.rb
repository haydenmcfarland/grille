# frozen_string_literal: true

module Mutations
  module Auth
    class SendResetPasswordInstructions < Mutations::BaseMutation
      field :send_reset_password_instructions, Boolean, null: true do
        description 'Send password reset instructions to users email'
        argument :email, String, required: true
      end

      def send_reset_password_instructions(email:)
        user = User.find_by_email(email)
        return true unless user

        user.send_reset_password_instructions
        true
      end
    end
  end
end
