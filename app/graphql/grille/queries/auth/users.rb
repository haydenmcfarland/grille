# frozen_string_literal: true

module Grille
  module Queries
    module Auth
      class Users < Grille::Queries::PaginatedQuery
        configure do |c|
          c.model_type = Grille::Types::Auth::UserType
        end
      end
    end
  end
end
