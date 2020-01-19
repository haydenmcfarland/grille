# frozen_string_literal: true

module Grille
  class Schema < GraphQL::Schema
    mutation(Types::MutationType)
    query(Types::QueryType)
  end
end
