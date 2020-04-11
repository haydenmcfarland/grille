# frozen_string_literal: true

module Grille
  # FIXME: need to support styles as well in single file components
  module ComponentImporter
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

    def call
      imports = Set.new
      result = Grille::Components::Base.descendants.map do |klass|
        component_name = klass.name.gsub('::', '').camelize
        begin
          mixin = component_name + 'Mixin'
          component = klass.new
          result = parse_vue_single_file_component(component.render)
          component_imports = result[:imports].split("\n").select do |s|
            s.include?('import')
          end
          new_imports = (component_imports - imports.to_a).join("\n")
          imports += component_imports

          if component.mixins
            import_mixins_js = <<-JS
            import #{mixin} from '#{component.mixins_path}';
            JS

            mixins_js = <<-JS
            mixins: [#{mixin}]
            JS
          end

          <<-JS
          #{import_mixins_js}
          #{new_imports}
          Vue.component('#{component_name}', {
            #{
              [
                result[:definitions],
                "template: #{result[:template].delete("\n").to_json}",
                mixins_js
              ].compact.join(",\n")
            }
          });
          JS
        rescue StandardError => e
          # pass
        end
      end.compact
      result.join("\n")
    end
  end
end
