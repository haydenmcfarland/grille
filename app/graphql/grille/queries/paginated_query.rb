# frozen_string_literal: true

require 'graphql'
require_relative '../../../../lib/grille/configurable'
require_relative '../../../../lib/ag_grid/adapter/filter'
require_relative '../../../../lib/ag_grid/adapter/sort'

module Grille
  module Queries
    # responsible for resolving model and types to utilize pagination
    class PaginatedQuery < GraphQL::Schema::Resolver
      extend Grille::Configurable

      class_attribute :model
      class_attribute :model_type
      class_attribute :filter_adapter
      class_attribute :sort_adapter

      class << self
        def default_config
          OpenStruct.new(
            sort_adapter: AgGrid::Adapter::Sort,
            filter_adapter: AgGrid::Adapter::Filter
          )
        end

        def build
          self.model ||= model_type.model
          class_eval do
            argument :page_size, Integer, required: true
            argument :page_number, Integer, required: true
            argument :sort_model, String, required: true
            argument :filter_model, String, required: true

            type model_type, null: false
          end

          key = model.name.demodulize.downcase.pluralize
          Grille::Mutations::Model.model_map[key] = model
        end
      end

      def query_page_count(query, page_size)
        (query.count.to_f / page_size).ceil.to_i
      end

      def query_page_rows(query, page_number, page_size)
        query.limit(page_size).offset((page_number - 1) * page_size)
      end

      def grille_resolver(page_size:, page_number:, sort_model:, filter_model:)
        query = model.read(context: context)
                     .order(model.primary_key)
                     .order(sort_adapter.parse(sort_model))
                     .where(filter_adapter.parse(filter_model))

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
