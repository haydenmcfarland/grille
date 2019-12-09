# frozen_string_literal: true

# FIXME: Dry Queries and Mutations
module Queries
  class BaseQuery < GraphQL::Schema::Resolver
    def grille_resolver(*_args)
      raise "'#{__method__}' must be declared in mutation"
    end

    def resolve(*args)
      return grille_resolver(*args)
    end
  end
end
