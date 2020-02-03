# frozen_string_literal: true

module Grille
  module Mutations
    module Model
      mattr_accessor :model_map, default: {}

      class << self
        def get_model_klass(model)
          klass = Grille::Mutations::Model.model_map[model]
          raise "unable to resolve model: #{model}" unless klass

          klass
        end
      end
    end
  end
end
