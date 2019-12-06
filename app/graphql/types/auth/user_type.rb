# frozen_string_literal: true

module Types
  module Auth
    class UserType < BaseObject
      field :id, ID, null: true
      field :name, String, null: true
      field :firstName, String, null: true
      field :lastName, String, null: true
      field :email, String, null: true
      field :token, String, null: true

      class << self
      end
    end
  end
end
