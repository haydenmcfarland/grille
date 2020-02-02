# frozen_string_literal: true

module Grille
  module Mutations
    module Model
      class Delete < Grille::Mutations::Base
        null true

        argument :model, String, required: true
        argument :ids, [ID], required: true

        field :result, GraphQL::Types::Boolean, null: false

        def grille_resolver(model:, ids:)
          # add default protection to base mutation
          user = context[:current_user]

          # FIXME: check permissions here
          return false if user.nil?

          # FIXME: make this more configurable and DRY as we are repeating
          klass = Grille::Mutations::Model.model_map[model]
          raise 'unable to resolve model' unless klass

          # FIXME: add some checks here and tighten permissions

          klass.delete(context: context, params: { id: ids })
          true
        end
      end
    end
  end
end
