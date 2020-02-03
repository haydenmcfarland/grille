# frozen_string_literal: true

module Grille
  module Mutations
    module Auth
      class TokenLogin < Grille::Mutations::Base
        null true

        description 'JWT token login'

        type Types::Auth::UserType

        def resolve
          user = context[:current_user]
          ::Grille::Mutations::Auth.user_to_hash(user)
        end
      end
    end
  end
end
