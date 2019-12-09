# frozen_string_literal: true

module Queries
  module Auth
    class Users < Queries::BaseQuery
      null true

      type [Types::Auth::UserType], null: false

      def grille_resolver
        User.all
      end
    end
  end
end
