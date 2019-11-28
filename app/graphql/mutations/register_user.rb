# frozen_string_literal: true

module Mutations
  class RegisterUser < Mutations::BaseMutation
    graphql_name 'RegisterUser'

    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: false

    def resolve(args)
      user = User.create!(args)

      # current_user needs to be set so authenticationToken can be returned
      context[:current_user] = user

      MutationResult.call(
        obj: { user: user },
        success: user.persisted?,
        errors: user.errors
      )
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{e.record.class.name}: " \
        "#{e.record.errors.full_messages.join(', ')}"
      )
    end
  end
end
