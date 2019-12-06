# frozen_string_literal: true

module Types
  class QueryType < BaseObject
    # ---- User ----
    field :me, Types::Auth::UserType, null: true do
      description 'Returns the current user'
    end
    def me(demo: false)
      context[:current_user]
    end
  end
end
