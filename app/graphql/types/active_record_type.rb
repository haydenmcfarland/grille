# frozen_string_literal: true

module Types
  class ActiveRecordType < GraphQL::Schema::Object
    field_class Types::BaseField

    TYPES = %i[boolean integer float string].to_set

    class << self
      def inherited(klass)
        TracePoint.trace(:end) do |t|
          # wait for the close of the inheriting class in order to determine
          # model type defined in inherting class
          next unless t.self == klass

          modules = klass.name.split('::')
          type_name = modules.pop + 'ActiveRecordPagination'
          hack = modules.map { |m| "module #{m}" }.join('; ')
          field_definition = klass.model.constantize.columns.map do |c|
            next if c.name == 'id'

            # default to String for types not in TYPES
            ctype = TYPES.member?(c.type) ? c.type.to_s.capitalize : 'String'

            "field :#{c.name}, #{ctype}, null: #{c.null}"
          end.compact.join("\n")

          unholy = <<-SORRY_MATZ
          #{hack}; class #{type_name} < BaseObject
                  field :id, ID, null: false
                  #{field_definition}
              end
            end
          end
          SORRY_MATZ

          # this ain't cool, but we a WIP so...
          eval(unholy)

          resolved_type = (modules + [type_name]).join('::')

          klass.class_eval <<-SORRY_MATZ, __FILE__, __LINE__ + 1
              field :total_pages, Integer, null: false
              field :rows, [#{resolved_type}], null: false
          SORRY_MATZ
        end
      end
    end
  end
end
