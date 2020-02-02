# frozen_string_literal: true

module Grille
  module Queries
    module Test
      class Tests < Grille::Queries::PaginatedQuery
        configure do |c|
          c.model_type = 'Grille::Types::Test::TestType'
        end
      end
    end
  end
end
