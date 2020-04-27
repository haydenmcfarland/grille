# frozen_string_literal: true

module Grille
  module Components
    class Grid < Base
      include Grille::Concerns::Endpoints

      class << self
        def js_path
          super.join('components/pages/Grid.vue.erb')
        end
      end

      endpoint(:say_hello) do |params|
        "Hi: #{params}"
      end
    end
  end
end
