# frozen_string_literal: true

module Grille
  module Components
    class Grid < Base
      COMPONENT_PATH = JS_PATH.join('components/pages/Grid.vue.erb')

      def render(template = File.read(COMPONENT_PATH))
        super(template)
      end

      def actions
        []
      end
    end
  end
end
