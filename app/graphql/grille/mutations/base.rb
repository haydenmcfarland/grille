# frozen_string_literal: true

module Grille
  module Mutations
    class Base < GraphQL::Schema::Mutation
      null false

      field :success, GraphQL::Types::Boolean, null: false
      field :errors, [GraphQL::Types::String], null: false

      def grille_resolver(*_args)
        raise "'#{__method__}' must be declared in mutation"
      end

      def active_record_result(result)
        {
          result.class.name.demodulize.downcase => result,
          success: result.persisted?,
          errors: result.errors
        }
      end

      def hash_result(result)
        {
          result: result.except('error', 'errors').to_json,
          success: true,
          errors: ([result['error']] + (result['errors'] || [])).compact
        }
      end

      def boolean_result(result)
        { result: result, success: true, errors: [] }
      end

      def nil_result(_result)
        null_obj_keys = self.class.fields.keys - %w[success errors]
        null_obj = null_obj_keys.each_with_object({}) { |k, h| h[k] = {} }
        null_obj.merge(success: false, errors: [])
      end

      def wrap_result(result)
        case result
        when ActiveRecord::Base
          active_record_result(result)
        when Hash
          hash_result(result)
        when TrueClass, FalseClass
          boolean_result(result)
        when nil
          nil_result(result)
        else
          raise "unsupported resolver type: '#{result.class}'"
        end
      end

      def resolve(*args)
        result = grille_resolver(*args)
        wrap_result(result)
      end
    end
  end
end
