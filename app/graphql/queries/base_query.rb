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

          type model_type, null: false
        end
      end
    end

    def grille_resolver(page_size:, page_number:)
      # FIXME: we should have a specific limit
      offset = (page_number - 1) * page_size

      # FIXME: CRUDContext needs to be updated as params isn't used
      # for where clause
      rows = self.class.model.read(context: context, params: {})
                 .order(created_at: :desc)
                 .limit(page_size).offset(offset)

      {
        rows: rows,
        total_pages: self.class.model.count / page_size + 1
      }
    end

    def resolve(*args)
      grille_resolver(*args)
    end
  end
end
