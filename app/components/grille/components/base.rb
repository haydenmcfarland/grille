# frozen_string_literal: true

require 'erb'

module Grille
  module Components
    class Base < OpenStruct
      attr_accessor :called_from

      JS_PATH = Pathname.new(File.join(__dir__, '../../../javascript/packs'))

      class << self
        def grille_ancestors
          self == Base ? [] : superclass.grille_ancestors + [self]
        end

        def inherited(klass)
          component_dir = begin
            cllr = if Kernel.respond_to?(:caller_locations)
                     location = caller_locations.first
                     location.absolute_path || location.path
                   else
                     caller.first.sub(/:\d+.*/, '')
                   end

            cllr[0..-4]
          end

          klass.define_method(:mixins_path) do
            "#{component_dir}/mixins.js"
          end

          klass.define_method(:mixins) do
            path = mixins_path
            File.read(path) if File.exist?(path)
          end
        end
      end

      def render(template)
        ERB.new(template).result(binding)
      end

      def actions
        []
      end
    end
  end
end
