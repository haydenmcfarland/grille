# frozen_string_literal: true

module Grille
  module Queries
    # responsible for resolving model and types to utilize pagination
    class PaginatedQuery < GraphQL::Schema::Resolver
      null true
      class_attribute :model
      class_attribute :model_type

      class << self
        def default_config
          OpenStruct.new({})
        end

        # FIXME: DRY
        def configure
          # FIXME: expand on configuration
          config = default_config
          yield(config) || {}

          # allow the passing of model_type as constant or string
          model_type = config.model_type.to_s

          raise 'no model type defined' unless model_type
          raise "model type does not exist: #{model_type}" unless
            const_defined?(model_type)

          create_paginated_query(config)
        end

        def create_paginated_query(config)
          self.model_type = config.model_type.constantize
          self.model = model_type.model

          class_eval do
            argument :page_size, Integer, required: true
            argument :page_number, Integer, required: true
            argument :sort_model, String, required: true
            argument :filter_model, String, required: true

            type config.model_type, null: false
          end

          key = model.name.demodulize.downcase.pluralize
          Grille::Mutations::Model.model_map[key] = model
        end
      end

      def text_filter(column, text)
        quoted = ActiveRecord::Base.connection.quote("%#{text}%")
        "#{column}::text LIKE #{quoted}"
      end

      def parse_sorters(sort_model)
        JSON.parse(sort_model).map do |sorter|
          { sorter['colId'].split('_').first.underscore => sorter['sort'] }
        end
      end

      def parse_multi_filter(column, filter)
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
          column = column.split('_').first.underscore

          raise 'not a column in model' unless
            model.column_names.include?(column)

          if filter.key?('condition1')
            parse_multi_filter(column, filter)
          elsif filter.key?('filter')
            text_filter(column, filter['filter'])
          end
        end.join(' AND ')
      end

      def query_page_count(query, page_size)
        (query.count.to_f / page_size).ceil.to_i
      end

      def query_page_rows(query, page_number, page_size)
        query.limit(page_size).offset((page_number - 1) * page_size)
      end

      def grille_resolver(page_size:, page_number:, sort_model:, filter_model:)
        query = self.class.model.read(context: context)
                    .order(self.class.model.primary_key)
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
end
