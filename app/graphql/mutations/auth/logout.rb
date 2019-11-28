# frozen_string_literal: true

module Mutations
  module Auth
    class Logout < Mutations::BaseMutation
      null true
      description 'Logout for users'
      type GraphQL::Types::Boolean

      def resolve
        if context[:current_user]
          context[:current_user].update(jti: SecureRandom.uuid)
          return true
        end
        false
      end
    end
  end
end
