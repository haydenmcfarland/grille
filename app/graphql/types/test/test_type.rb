# frozen_string_literal: true

module Types
  module Test
    class TestType < ActiveRecordType
      class << self
        def model
          'Test'
        end
      end
    end
  end
end
