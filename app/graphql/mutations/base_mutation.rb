# frozen_string_literal: true

class Mutations::BaseMutation < GraphQL::Schema::Mutation
  null false

  field :success, GraphQL::Types::Boolean, null: false
  field :errors, [GraphQL::Types::String], null: false

  def grille_resolver(*_args)
    raise "\'#{__method__}' must be declared in mutation"
  end

  def resolve(*args)
    result = grille_resolver(*args)

    if result.is_a?(ActiveRecord::Base)
      Mutations::MutationResult.call(
        obj: { result.class.name.demodulize.downcase => result },
        success: result.persisted?,
        errors: result.errors
      )
    elsif [true, false].include?(result)
      Mutations::MutationResult.call(
        obj: { result: result },
        success: result,
        errors: []
      )
    elsif result.nil?
      Mutations::MutationResult.call(
        obj: { user: Types::Auth::UserType.empty },
        success: false,
        errors: []
      )
    else
      raise "unsupported resolver type: '#{result.class}'"
    end
  end
end
