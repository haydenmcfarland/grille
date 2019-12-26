# frozen_string_literal: true

module Types
  class BaseType < GraphQL::Schema::Object
    field_class Types::BaseField

    class << self
      def inherited(klass)
        type_name = 'Dynamic' + klass.name.demodulize
        binding.pry
        z = <<~MODULE
        module Types
          module Test
            class #{type_name} < BaseObject
              field :id, ID, null: false
              field :name, String, null: false
              field :details, String, null: true
              field :age, Integer, null: true
            end
          end
        end
      MODULE
      binding.pry
        eval <<~MODULE
          module Types
            module Test
              class #{type_name} < BaseObject
                field :id, ID, null: false
                field :name, String, null: false
                field :details, String, null: true
                field :age, Integer, null: true
              end
            end
          end
        MODULE

        klass.class_eval do
          field :total_pages, Integer, null: false
          field :rows, [type_name.constantize], null: false
        end
      end
    end
  end
end
