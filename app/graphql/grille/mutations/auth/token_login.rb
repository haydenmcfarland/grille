# frozen_string_literal: true

module Grille
  module Mutations
    module Auth
      class TokenLogin < Grille::Mutations::Base
        null true

        description 'JWT token login'

        type Types::Auth::UserType

        def resolve
          context[:current_user]
        end
      end
    end
  end
end
