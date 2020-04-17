# frozen_string_literal: true

module Vue
  # FIXME: need to support styles as well in single file components
  class InlineTemplateComponent
    attr_accessor :name, :definition, :template, :style, :mixins

    def initialize(name:, definition:, template:, mixins:, style: nil)
      @name = name
      @definition = definition
      @template = template
      @mixins = mixins
      @style = style
    end

    def mixins_js
      <<-JS
      mixins: [#{mixins.join(', ')}]
      JS
    end

    def template_js
      <<-JS
      template: #{template.delete("\n").to_json}
      JS
    end

    def render
      <<-JS
      const #{name} = Vue.component('#{name}', {
        #{
          [
            definition,
            template_js,
            mixins_js
          ].compact.join(",\n")
        }
      });
      JS
    end
  end
end
