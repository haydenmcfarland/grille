# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null false

    field :success, GraphQL::Types::Boolean, null: false
    field :errors, [GraphQL::Types::String], null: false

    def grille_resolver(*_args)
      raise "'#{__method__}' must be declared in mutation"
    end

    def wrap_result(result)
      if result.is_a?(ActiveRecord::Base)
        return {
          result.class.name.demodulize.downcase => result,
          success: result.persisted?,
          errors: result.errors
        }
      end

      if [true, false].include?(result)
        return { result: result, success: true, errors: [] }
      end

      if result.nil?
        null_obj_keys = self.class.fields.keys - %w[success errors]
        null_obj = null_obj_keys.each_with_object({}) { |k, h| h[k] = {} }
        return null_obj.merge(success: false, errors: [])
      end

      raise "unsupported resolver type: '#{result.class}'"
    end

    def resolve(*args)
      result = grille_resolver(*args)
      wrap_result(result)
    end
  end
end
