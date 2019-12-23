# frozen_string_literal: true

module Queries
  module Testa
    class Tests < Queries::BaseQuery
      null true

      type [Types::Test::TestType], null: false

      def grille_resolver
        Test.all
      end
    end
  end
end
