# frozen_string_literal: true

module Types
  module Auth
    class UserType < BaseObject
      field :id, ID, null: false
      field :name, String, null: false
      field :firstName, String, null: false
      field :lastName, String, null: false
      field :email, String, null: false
      field :token, String, null: false
    end
  end
end