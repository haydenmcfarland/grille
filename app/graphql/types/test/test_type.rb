# frozen_string_literal: true

module Types
  module Test
    class TestType < BaseType
      class << self
        def columns
          Test.columns
        end
      end
    end
  end
end
