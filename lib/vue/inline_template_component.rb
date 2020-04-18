# frozen_string_literal: true

module Vue
  # FIXME: need to support styles as well in single file components
  class InlineTemplateComponent
    attr_accessor :name, :definition, :template, :style, :mixins, :global

    def initialize(
      name:,
      definition:,
      template:,
      mixins:,
      style: nil,
      global: true
    )
      @name = name
      @definition = definition
      @template = template
      @mixins = mixins
      @style = style
      @global = global
    end

    def mixins_js
      "mixins: [#{mixins.join(', ')}]"
    end

    def template_js
      "template: #{template.delete("\n").to_json}"
    end

    def register(name, js)
      <<-JS
      Vue.component('#{name}', {
        #{js}
      });
      JS
    end

    def render
      js = [
        definition,
        template_js,
        mixins_js
      ].compact.join(",\n")

      "const #{name} = #{global ? register(name, js) : "{#{js}}"}"
    end
  end
end
