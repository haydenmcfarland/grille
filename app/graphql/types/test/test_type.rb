# frozen_string_literal: true

module Types
  module Test
    class TestType < ActiveRecordType
      configure do |c|
        c.model = 'Test'
      end
    end
  end
end
