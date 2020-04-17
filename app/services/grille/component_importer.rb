# frozen_string_literal: true

require_relative '../../../lib/vue/single_file_component'
require_relative '../../../lib/vue/inline_template_component'

module Grille
  module ComponentImporter
    mattr_accessor :component_names, default: {}
    mattr_accessor :mixin_names, default: {}
    mattr_accessor :component_imports, default: Set.new

    COMPONENTS_PATH = Pathname.new(
      File.join(__dir__, '../../components/grille/components')
    )

    RAILS_APP_COMPONENTS_PATH = Rails.root.join('app/components')

    Dir[COMPONENTS_PATH + '**/*.rb'].sort.each { |f| require f }
    Dir[RAILS_APP_COMPONENTS_PATH + '**/*.rb'].sort.each { |f| require f }

    module_function

    def component_name(klass)
      component_names[klass] ||= klass.name.gsub('::', '').camelize
    end

    def mixin_name(klass)
      mixin_names[klass] ||= component_name(klass) + 'Mixin' if klass.mixins
    end

    def call
      Grille::Components::Base.descendants.map do |klass|
        grille_component = klass.new
        sfc = ::Vue::SingleFileComponent.new(grille_component.render)

        new_imports = (sfc.imports - component_imports.to_a).join("\n")
        self.component_imports += sfc.imports

        mixins = klass.grille_ancestors.map { |a| mixin_name(a) }.compact
        if mixins.present?
          mixin_imports = klass.grille_ancestors.map do |k|
            "import #{mixin_name(k)} from '#{k.mixins_path}';"
          end

          new_mixin_imports = (
            mixin_imports - component_imports.to_a
          ).join("\n")
          self.component_imports += mixin_imports
        end

        inline_component = ::Vue::InlineTemplateComponent.new(
          name: component_name(klass),
          definition: sfc.definition,
          template: sfc.template,
          mixins: mixins
        ).render

        [new_mixin_imports, new_imports, inline_component].compact.join("\n")
      end.compact.join("\n")
    end
  end
end
