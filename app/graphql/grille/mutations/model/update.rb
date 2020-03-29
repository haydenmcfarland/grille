# frozen_string_literal: true

module Grille
  module Mutations
    module Model
      class Update < Grille::Mutations::Base
        argument :model, String, required: true
        argument :json_array, [String], required: true

        field :result, GraphQL::Types::Boolean, null: false

        def massage_params(params)
          params.transform_keys(&:underscore).except('__typename')
        end

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
              obj.update!(massage_params(r))
            end
            new_rows.each { |r| klass.create!(massage_params(r)).save! }
          end
          true
        end
      end
    end
  end
end
