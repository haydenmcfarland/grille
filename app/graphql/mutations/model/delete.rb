# frozen_string_literal: true

module Mutations
  module Model
    class Delete < Mutations::BaseMutation
      null true

      argument :model, String, required: true
      argument :ids, [ID], required: true

      field :result, GraphQL::Types::Boolean, null: false

      def grille_resolver(model:, ids:)
        # add default protection to base mutation
        user = context[:current_user]

        # this shouldn't be here (specific id check)
        return false if user.nil? || ids.include?(user.id.to_s)

        # FIXME: add some checks here and tighten permissions
        model.singularize.capitalize.constantize.where(id: ids).delete_all
        true
      end
    end
  end
end
