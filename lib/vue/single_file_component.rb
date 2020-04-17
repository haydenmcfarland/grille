# frozen_string_literal: true

module Vue
  class SingleFileComponent
    attr_accessor :definition, :imports, :style, :template

    ML = Regexp::MULTILINE
    REG_IMPORT = Regexp.new('<script>(.*)export default.*</script>', ML)
    REG_DEFINITION = Regexp.new('<script>*export default {(.*)}.*</script>', ML)
    REG_STYLE = Regexp.new('<style>(.*)</style>', ML)
    REG_TEMPLATE = Regexp.new('<template>(.*)</template>', ML)

    def initialize(component_string)
      @definition = component_string.match(REG_DEFINITION)&.[](1)
      @imports = component_string.match(REG_IMPORT)&.[](1)
      @style = component_string.match(REG_STYLE)&.[](1)
      @template = component_string.match(REG_TEMPLATE)&.[](1)
    end
  end
end
