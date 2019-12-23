# frozen_string_literal: true

module Types
  module Test
    class TestType < BaseObject
      field :id, ID, null: false
      field :name, String, null: false
      field :details, String, null: true
      field :age, Integer, null: true
    end
  end
end
