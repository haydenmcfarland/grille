# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    mutations_path = Rails.root.join('app', 'graphql', 'mutations')
    mutations_paths = Pathname.new(mutations_path).children.select(&:directory?)

    mutations = mutations_paths.map do |path|
      Dir[path.join('**', '*.rb')].map do |file|
        mod, klass = file.split(mutations_path.to_s + '/').last.split('/')
        [mod, klass.chomp('.rb')]
      end
    end.flatten(1)

    mutations.each do |mod, klass|
      field klass.to_sym, mutation:
      "Mutations::#{mod.camelize}::#{klass.camelize}".constantize
    end
  end
end
