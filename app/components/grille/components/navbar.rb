# frozen_string_literal: true

module Grille
  module Components
    class Navbar < Base
      class << self
        def js_path
          super.join('components/Navbar.vue.erb')
        end
      end
    end
  end
end
