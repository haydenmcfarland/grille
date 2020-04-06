# frozen_string_literal: true

module Grille
  module Components
    class Grid < Base
      class << self
        def render_component
          t = File.read(JS_PATH.join('components/pages/Grid.vue.erb'))
          render_from_file(
            t,
            {
              actions: []
            }
          )
        end
      end
    end
  end
end
