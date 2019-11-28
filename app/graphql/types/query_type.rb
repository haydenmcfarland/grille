# frozen_string_literal: true

module Types
  class QueryType < BaseObject
    field :user,
          Types::UserType,
          null: false,
          description: 'Returns user information' do
            argument :id, ID, required: true
          end

    def user(id:)
      User.find(id)
    end
  end
end
