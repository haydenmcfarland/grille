# frozen_string_literal: true

module Queries
  module Auth
    class Users < Queries::BaseQuery
      null true

      argument :page_size, Integer, required: true
      argument :page_number, Integer, required: true

      type [Types::Auth::UserType], null: false

      def grille_resolver(page_size:, page_number:)
        offset = page_number * page_size
        User.order(created_at: :desc).limit(page_size).offset(offset)
      end
    end
  end
end
