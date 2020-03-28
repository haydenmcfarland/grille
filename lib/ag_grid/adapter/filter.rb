# frozen_string_literal: true

module AgGrid
  module Adapter
    module Filter
      module_function

      def text_filter(column, text)
        quoted = ActiveRecord::Base.connection.quote("%#{text}%")
        "#{column}::text LIKE #{quoted}"
      end

      def parse_multi(column, filter)
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
      def parse(filter_model)
        JSON.parse(filter_model).map do |column, filter|
          column = column.split('_').first.underscore
          if filter.key?('condition1')
            parse_multi(column, filter)
          elsif filter.key?('filter')
            text_filter(column, filter['filter'])
          end
        end.join(' AND ')
      end
    end
  end
end
