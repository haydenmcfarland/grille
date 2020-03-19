# frozen_string_literal: true

module Grille
  module Types
    class QueryType < Types::BaseObject
      # FIXME: dry mutations and query type
      queries_path = File.expand_path('../queries', __dir__)
      queries_paths = Pathname.new(queries_path).children.select(&:directory?)

      queries = queries_paths.flat_map do |path|
        Dir[path.join('**', '*.rb')].map do |file|
          mod, klass = file.split(queries_path.to_s + '/').last.split('/')
          [mod, klass.chomp('.rb')]
        end
      end

      queries.map do |mod, klass|
        field klass.to_sym, resolver:
        "Grille::Queries::#{mod.camelize}::#{klass.camelize}".constantize,
                            null: true
      end
    end
  end
end
