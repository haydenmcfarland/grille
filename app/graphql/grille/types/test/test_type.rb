# frozen_string_literal: true

module Grille
  module Types
    module Test
      class TestType < Grille::Types::ActiveRecordType
        configure do |c|
          c.model = 'Grille::Test'
        end
      end
    end
  end
end