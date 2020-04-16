# frozen_string_literal: true

module Grille
  module Components
    class App < Base
      class << self
        def js_path
          super.join('components/App.vue.erb')
        end
      end

      def configuration
        { navbar_element: navbar_element }
      end

      def navbar_klass
        Navbar
      end

      def navbar_element
        Grille::ComponentImporter.component_name(navbar_klass)
      end
    end
  end
end
