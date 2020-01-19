# frozen_string_literal: true

module Grille
  module Types
    class QueryType < Types::BaseObject
      # FIXME: dry mutations and query type
      queries_path = Rails.root.join('app', 'graphql', 'grille', 'queries')
      queries_paths = Pathname.new(queries_path).children.select(&:directory?)

      queries = queries_paths.map do |path|
        Dir[path.join('**', '*.rb')].map do |file|
          mod, klass = file.split(queries_path.to_s + '/').last.split('/')
          [mod, klass.chomp('.rb')]
        end
      end.flatten(1)

      queries.map do |mod, klass|
        field klass.to_sym, resolver:
        "Grille::Queries::#{mod.camelize}::#{klass.camelize}".constantize,
                            null: true
      end
    end
  end
end
