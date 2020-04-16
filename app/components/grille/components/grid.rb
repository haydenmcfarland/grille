# frozen_string_literal: true

module Grille
  module Components
    class Grid < Base
      class << self
        def js_path
          super.join('components/pages/Grid.vue.erb')
        end
      end

      def actions
        []
      end
    end
  end
end
