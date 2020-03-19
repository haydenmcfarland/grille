# frozen_string_literal: true

module Grille
  module Types
    class MutationType < Types::BaseObject
      mutations_path = File.expand_path('../mutations', __dir__)
      mutations_paths = Pathname.new(mutations_path).children
                                .select(&:directory?)

      mutations = mutations_paths.flat_map do |path|
        Dir[path.join('**', '*.rb')].map do |file|
          mod, klass = file.split(mutations_path.to_s + '/').last.split('/')
          [mod, klass.chomp('.rb')]
        end
      end

      mutations.each do |mod, klass|
        field klass.to_sym, mutation:
        "Grille::Mutations::#{mod.camelize}::#{klass.camelize}".constantize
      end
    end
  end
end
