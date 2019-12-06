# frozen_string_literal: true

module Mutations
  module Auth
    class SignOut < Mutations::BaseMutation
      null true

      description 'Logout for users'

      field :result, GraphQL::Types::Boolean, null: false
      # type GraphQL::Types::Boolean

      def grille_resolver
        if context[:current_user]
          context[:current_user].update(jti: SecureRandom.uuid)
          return true
        end
        false
      end
    end
  end
end
