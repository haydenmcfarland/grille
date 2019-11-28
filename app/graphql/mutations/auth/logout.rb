# frozen_string_literal: true

module Mutations
  module Auth
    class Logout < Mutations::BaseMutation
      field :logout, Boolean, null: true do
        description 'Logout for users'
      end

      def logout
        if context[:current_user]
          context[:current_user].update(jti: SecureRandom.uuid)
          return true
        end
        false
      end
    end
  end
end
