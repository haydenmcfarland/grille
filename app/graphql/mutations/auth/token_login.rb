# frozen_string_literal: true

module Mutations
  module Auth
    class TokenLogin < Mutations::BaseMutation
      null true

      description 'JWT token lgin'

      type Types::Auth::UserType

      def resolve
        context[:current_user]
      end
    end
  end
end
