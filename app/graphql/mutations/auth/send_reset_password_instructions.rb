# frozen_string_literal: true

module Mutations
  module Auth
    class SendResetPasswordInstructions < Mutations::BaseMutation
      null true

      description 'Send password reset instructions to users email'
      argument :email, String, required: true

      type GraphQL::Types::Boolean

      def resolve(email:)
        user = User.find_by_email(email)
        return true unless user

        user.send_reset_password_instructions
        true
      end
    end
  end
end
