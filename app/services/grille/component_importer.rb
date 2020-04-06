# frozen_string_literal: true

module Grille
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
      result = Grille::Components::Base.descendants.map do |klass|
        component_name = klass.name.gsub('::', '').camelize
        begin
          result = parse_vue_single_file_component(klass.new.render)
          <<-JS
          #{result[:imports]}
          Vue.component('#{component_name}', {
            #{result[:definition]},
            template: '#{result[:template].delete("\n")}'
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
