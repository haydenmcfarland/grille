# frozen_string_literal: true

module AgGrid
  module Adapter
    module Sort
      module_function

      def parse(sort_model)
        JSON.parse(sort_model).map do |sorter|
          { sorter['colId'].split('_').first.underscore => sorter['sort'] }
        end
      end
    end
  end
end
