# frozen_string_literal: true

# FIXME: Dry Queries and Mutations
module Queries
  class BaseQuery < GraphQL::Schema::Resolver
    null true
    class_attribute :model
    class_attribute :model_type

    class << self
      # FIXME: this forces a very specific convention
      # maybe do this a different way?
      def inherited(klass)
        klass.model = klass.name.demodulize.singularize.constantize
        modules = klass.name.split('::')[1..]
        modules[-1] = modules[-1].singularize + 'Type'
        klass.model_type = 'Types::' + modules.join('::')

        klass.class_eval do
          argument :page_size, Integer, required: true
          argument :page_number, Integer, required: true

          type [model_type], null: false
        end
      end
    end

    def grille_resolver(page_size:, page_number:)
      offset = page_number * page_size
      self.class.model.order(created_at: :desc).limit(page_size).offset(offset)
    end

    def resolve(*args)
      grille_resolver(*args)
    end
  end
end
