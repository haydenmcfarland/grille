# frozen_string_literal: true

class Mutations::BaseMutation < GraphQL::Schema::Mutation
  null false

  def grille_resolver(*_args)
    raise '\'grille_resolver\' not declared in mutation'
  end

  def resolve(*args)
    result = grille_resolver(*args)

    if result.is_a?(ActiveRecord::Base)
      Mutations::MutationResult.call(
        obj: { result.class.name.demodulize.downcase => result },
        success: result.persisted?,
        errors: result.errors
      )
    else
      raise "unsupported resolver type: '#{result.class}'"
    end
  end
end
