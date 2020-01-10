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
          argument :sort_model, String, required: true
          argument :filter_model, String, required: true

          type model_type, null: false
        end
      end
    end

    def text_filter(column, text)
      quoted = ActiveRecord::Base.connection.quote("%#{text}%")
      "#{column} LIKE #{quoted}"
    end

    def grille_resolver(page_size:, page_number:, sort_model:, filter_model:)
      # FIXME: we should have a specific limit
      offset = (page_number - 1) * page_size

      # FIXME: CRUDContext needs to be updated as params isn't used
      # for where clause

      sorters = JSON.parse(sort_model).map do |sorter|
        {
          # FIXME: hacky need to map this with label (pass more meta)
          sorter['colId'].split('_').first.to_sym => sorter['sort'].to_sym
        }
      end

      # FIXME: assumes text filter / have multiple support
      sql_filter = JSON.parse(filter_model).map do |column, filter|
        column = column.split('_').first

        raise 'not a column in model' unless model.column_names.include?(column)

        if filter.key?('condition1')
          x, y = [1, 2].map { |i| filter.dig("condition#{i}", 'filter') }
          if x == y
            text_filter(column, x)
          else
            "#{text_filter(column, x)} "\
            "#{filter['operator']} "\
            "#{text_filter(column, y)}"
          end
        elsif filter.key?('filter')
          text_filter(column, filter['filter'])
        end
      end.join(' AND ')

      rows = self.class.model.read(context: context, params: {})
                 .order(created_at: :desc)
                 .order(sorters)
                 .where(sql_filter)
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
