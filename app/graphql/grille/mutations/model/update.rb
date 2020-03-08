# frozen_string_literal: true

module Grille
  module Mutations
    module Model
      class Update < Grille::Mutations::Base
        null true

        argument :model, String, required: true
        argument :json_array, [String], required: true

        field :result, GraphQL::Types::Boolean, null: false

        def grille_resolver(model:, json_array:)
          user = context[:current_user]
          return false if user.nil?

          klass = ::Grille::Mutations::Model.get_model_klass(model)

          # FIXME: replace newOrModified
          data = json_array.map { |j| JSON.parse(j).except('newOrModified') }

          row_updates = data.select { |o| o['__typename'].present? }
          new_rows = data - row_updates

          ActiveRecord::Base.transaction do
            row_updates.each do |r|
              obj = klass.find(r['id'])

              # FIXME: massage params from js
              params = r.transform_keys(&:underscore).except('__typename')
              obj.update!(params)
            end
            new_rows.each do |r|
              klass.create!(r).save!
            end
          end
          true
        end
      end
    end
  end
end
