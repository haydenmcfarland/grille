# frozen_string_literal: true

module Mutations
  module Auth
    class TokenLogin < Mutations::BaseMutation
      field :token_login, Types::UserType, null: true do
        description 'JWT token login'
      end

      def token_login
        context[:current_user]
      end
    end
  end
end
