# frozen_string_literal: true

module Grille
  # FIXME: need to support styles as well in single file components
  module ComponentImporter
    # need to also grab engine components;
    # this should be configurable form the rails
    COMPONENTS_PATH = Pathname.new(
      File.join(__dir__, '../../components/grille/components')
    )

    Dir[COMPONENTS_PATH + '**/*.rb'].sort.each { |f| require f }

    REG_EXP_SCRIPT_IMPORTS = Regexp.new(
      '<script>(.*)export default.*</script>',
      Regexp::MULTILINE
    )
    REG_EXP_SCRIPT_DEFINITION = Regexp.new(
      '<script>.*export default {(.*)}.*</script>',
      Regexp::MULTILINE
    )
    REG_EXP_STYLE = Regexp.new('<style>(.*)</style>', Regexp::MULTILINE)
    REG_EXP_TEMPLATE = Regexp.new('<template>(.*)</template>', Regexp::MULTILINE)

    module_function

    def parse_vue_single_file_component(file)
      {
        definition: file.match(REG_EXP_SCRIPT_DEFINITION)&.[](1),
        imports: file.match(REG_EXP_SCRIPT_IMPORTS)&.[](1),
        style: file.match(REG_EXP_STYLE)&.[](1),
        template: file.match(REG_EXP_TEMPLATE)&.[](1)
      }
    end

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
      result = Grille::Components::Base.descendants.map do |klass|
        component = klass.new
        result = parse_vue_single_file_component(component.render)
        component_imports = result[:imports].split("\n").select do |s|
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

          mixins_js = <<-JS
            mixins: [#{mixins.join(', ')}]
          JS
        end

        template_js = <<-JS
            template: #{result[:template].delete("\n").to_json}
        JS

        <<-JS
          #{new_mixin_imports}
          #{new_imports}
          Vue.component('#{component_name(klass)}', {
            #{
              [
                result[:definitions],
                template_js,
                mixins_js
              ].compact.join(",\n")
            }
          });
        JS
      end.compact
      result.join("\n")
    end
  end
end
