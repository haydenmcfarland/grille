# frozen_string_literal: true

require 'graphql'

module Grille
  class Schema < GraphQL::Schema
    mutation(Types::MutationType)
    query(Types::QueryType)
  end
end
