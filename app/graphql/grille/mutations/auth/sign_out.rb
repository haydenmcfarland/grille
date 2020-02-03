# frozen_string_literal: true

module Grille
  module Mutations
    module Auth
      class SignOut < Grille::Mutations::Base
        null true

        description 'Logout for users'

        field :result, GraphQL::Types::Boolean, null: false

        def grille_resolver
          user = context[:current_user]
          user&.update!(jti: SecureRandom.uuid)
        end
      end
    end
  end
end
