# frozen_string_literal: true

require_relative '../../../lib/vue/single_file_component'

module Grille
  # FIXME: need to support styles as well in single file components
  module ComponentImporter
    COMPONENTS_PATH = Pathname.new(
      File.join(__dir__, '../../components/grille/components')
    )

    RAILS_APP_COMPONENTS_PATH = Rails.root.join('app/components')

    Dir[COMPONENTS_PATH + '**/*.rb'].sort.each { |f| require f }
    Dir[RAILS_APP_COMPONENTS_PATH + '**/*.rb'].sort.each { |f| require f }

    module_function

    def component_name(klass)
      @@component_names ||= {}
      @@component_names[klass] ||= klass.name.gsub('::', '').camelize
    end

    def mixin_name(klass)
      @@mixin_names ||= {}
      @@mixin_names[klass] ||= component_name(klass) + 'Mixin' if klass.mixins
    end

    # FIXME: time to DRY and refactorino
    def call
      imports = Set.new
      Grille::Components::Base.descendants.map do |klass|
        component = klass.new
        vue_component = ::Vue::SingleFileComponent.new(component.render)
        component_imports = vue_component.imports.split("\n").select do |s|
          s.include?('import')
        end
        new_imports = (component_imports - imports.to_a).join("\n")
        imports += component_imports

        mixins = klass.grille_ancestors.map { |a| mixin_name(a) }.compact
        if mixins.present?
          mixin_imports = klass.grille_ancestors.map do |k|
            <<-JS
              import #{mixin_name(k)} from '#{k.mixins_path}';
            JS
          end

          new_mixin_imports = (mixin_imports - imports.to_a).join("\n")
          imports += mixin_imports

          mixins_js = <<-JS
            mixins: [#{mixins.join(', ')}]
          JS
        end

        template_js = <<-JS
            template: #{vue_component.template.delete("\n").to_json}
        JS

        <<-JS
          #{new_mixin_imports}
          #{new_imports}
          const #{component_name(klass)} = Vue.component('#{component_name(klass)}', {
            #{
              [
                vue_component.definition,
                template_js,
                mixins_js
              ].compact.join(",\n")
            }
          });
        JS
      end.compact.join("\n")
    end
  end
end
