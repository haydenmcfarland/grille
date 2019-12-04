# frozen_string_literal: true

module Types
  module Auth
    class UserType < BaseObject
      field :id, ID, null: false
      field :name, String, null: false
      field :firstName, String, null: false
      field :lastName, String, null: false
      field :email, String, null: true
      field :token, String, null: false

      class << self
        def empty
          OpenStruct.new(
            id: '',
            name: '',
            firstName: '',
            lastName: '',
            email: '',
            token: ''
          )
        end
      end
    end
  end
end
