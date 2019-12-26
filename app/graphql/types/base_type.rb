# frozen_string_literal: true

module Types
  class BaseType < GraphQL::Schema::Object
    field_class Types::BaseField

    class << self
      def inherited(klass)
        TracePoint.trace(:end) do |t|
          modules = klass.name.split('::')
          type_name = 'Dynamic' + modules.pop
          hack = modules.map { |m| "module #{m}" }.join('; ')
          binding.pry
          hackery = <<~MODULE
            #{hack}; class #{type_name} < BaseObject
                    field :id, ID, null: false
                    field :name, String, null: false
                    field :details, String, null: true
                    field :age, Integer, null: true
                end
              end
            end
          MODULE

          eval hackery

          resolved_type = (modules + [type_name]).join('::')

          klass.class_eval <<-HACK
              field :total_pages, Integer, null: false
              field :rows, [#{resolved_type}], null: false
          HACK
        end
      end
    end
  end
end
