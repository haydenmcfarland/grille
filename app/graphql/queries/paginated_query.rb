# frozen_string_literal: true

module Queries
  # responsible for resolving model and types to utilize pagination
  class PaginatedQuery < GraphQL::Schema::Resolver
    null true
    class_attribute :model
    class_attribute :model_type

    class << self
      def resolve_model(klass)
        klass.name.demodulize.singularize.constantize
      end

      def resolve_query_type(klass)
        modules = klass.name.split('::')[1..]
        "Types::#{(modules << modules.pop.singularize + 'Type').join('::')}"
      end

      def inherited(klass)
        klass.model = resolve_model(klass)
        klass.model_type = resolve_query_type(klass)
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
      "#{column}::text LIKE #{quoted}"
    end

    def parse_sorters(sort_model)
      JSON.parse(sort_model).map do |sorter|
        { sorter['colId'].split('_').first => sorter['sort'] }
      end
    end

    def parse_multi_filter(filter)
      x, y = [1, 2].map { |i| filter.dig("condition#{i}", 'filter') }
      if x == y
        text_filter(column, x)
      else
        "#{text_filter(column, x)} "\
        "#{filter['operator']} "\
        "#{text_filter(column, y)}"
      end
    end

    # FIXME: assumes text filter; does not support all ag-Grid filter options
    def parse_filter(filter_model)
      JSON.parse(filter_model).map do |column, filter|
        column = column.split('_').first

        raise 'not a column in model' unless model.column_names.include?(column)

        if filter.key?('condition1')
          parse_multi_filter(filter)
        elsif filter.key?('filter')
          text_filter(column, filter['filter'])
        end
      end.join(' AND ')
    end

    def query_page_count(query, page_size)
      query.count / page_size + 1
    end

    def query_page_rows(query, page_number, page_size)
      query.limit(page_size).offset((page_number - 1) * page_size)
    end

    # FIXME: CRUDContext needs to be updated as params isn't used
    def grille_resolver(page_size:, page_number:, sort_model:, filter_model:)
      query = self.class.model.read(context: context, params: {})
                  .order(parse_sorters(sort_model))
                  .where(parse_filter(filter_model))

      rows = query_page_rows(query, page_number, page_size)
      total_pages = query_page_count(query, page_size)

      { rows: rows, total_pages: total_pages }
    end

    def resolve(*args)
      grille_resolver(*args)
    end
  end
end
