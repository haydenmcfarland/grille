# frozen_string_literal: true

require 'erb'

module Grille
  module Components
    class Base < OpenStruct
      JS_PATH = Pathname.new(File.join(__dir__, '../../../javascript/packs'))

      def render(template)
        ERB.new(template).result(binding)
      end

      class << self
        def render_from_hash(t, h)
          new(h).render(t)
        end

        def render_component; end
      end
    end
  end
end
