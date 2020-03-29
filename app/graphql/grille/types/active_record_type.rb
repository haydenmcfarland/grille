# frozen_string_literal: true

require_relative '../../../../lib/grille/configurable'

module Grille
  module Types
    class ActiveRecordType < GraphQL::Schema::Object
      extend Grille::Configurable

      class_attribute :model

      field_class Types::BaseField

      TYPES = %i[boolean integer float string].to_set
      TYPE_MAP = {
        'Integer' => 'Int'
      }.freeze

      TYPE_TAG = 'Pagination'

      class << self
        def build
          modules = name.split('::')
          type_name = modules.pop + TYPE_TAG

          pagination_klass = Class.new BaseObject do
            GraphQL::Schema::Object.field :id, GraphQL::Types::ID, null: false

            model.constantize.columns.each do |c|
              next if c.name == 'id'

              # default to String for types not in TYPES
              ctype = TYPES.member?(c.type) ? c.type.to_s.capitalize : 'String'

              GraphQL::Schema::Object.field(
                c.name.to_sym,
                "GraphQL::Types::#{TYPE_MAP[ctype] || ctype}".constantize,
                null: c.null
              )
            end
          end

          namespace = name.split('::')[0...-1].join('::').constantize
          klass_type = namespace.const_set(type_name, pagination_klass)

          class_eval do
            GraphQL::Schema::Object.field :total_pages, Integer, null: false
            GraphQL::Schema::Object.field :rows, [klass_type], null: false
          end
        end
      end
    end
  end
end
