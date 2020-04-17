# frozen_string_literal: true

require_relative '../../../lib/vue/single_file_component'
require_relative '../../../lib/vue/inline_template_component'

module Grille
  module ComponentImporter
    mattr_accessor :component_names, :mixin_names
    COMPONENTS_PATH = Pathname.new(
      File.join(__dir__, '../../components/grille/components')
    )

    RAILS_APP_COMPONENTS_PATH = Rails.root.join('app/components')

    Dir[COMPONENTS_PATH + '**/*.rb'].sort.each { |f| require f }
    Dir[RAILS_APP_COMPONENTS_PATH + '**/*.rb'].sort.each { |f| require f }

    module_function

    def component_name(klass)
      component_names ||= {}
      component_names[klass] ||= klass.name.gsub('::', '').camelize
    end

    def mixin_name(klass)
      mixin_names ||= {}
      mixin_names[klass] ||= component_name(klass) + 'Mixin' if klass.mixins
    end

    def call
      imports = Set.new
      Grille::Components::Base.descendants.map do |klass|
        grille_component = klass.new
        vue_component = ::Vue::SingleFileComponent.new(grille_component.render)

        new_imports = (vue_component.imports - imports.to_a).join("\n")
        imports += vue_component.imports

        mixins = klass.grille_ancestors.map { |a| mixin_name(a) }.compact
        if mixins.present?
          mixin_imports = klass.grille_ancestors.map do |k|
            <<-JS
                import #{mixin_name(k)} from '#{k.mixins_path}';
            JS
          end

          new_mixin_imports = (mixin_imports - imports.to_a).join("\n")
          imports += mixin_imports
        end

        # FIXME: need to support styles as well in single file components
        inline_component = ::Vue::InlineTemplateComponent.new(
          name: component_name(klass),
          definition: vue_component.definition,
          template: vue_component.template,
          mixins: mixins
        ).render

        [new_mixin_imports, new_imports, inline_component].join("\n")
      end.compact.join("\n")
    end
  end
end
