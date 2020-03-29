# frozen_string_literal: true

module Grille
  module Mutations
    module Model
      class Delete < Grille::Mutations::Base
        argument :model, String, required: true
        argument :ids, [ID], required: true

        field :result, GraphQL::Types::Boolean, null: false

        def grille_resolver(model:, ids:)
          user = context[:current_user]
          return false if user.nil?

          klass = ::Grille::Mutations::Model.get_model_klass(model)
          klass.delete(context: context, params: { id: ids })
          true
        end
      end
    end
  end
end
