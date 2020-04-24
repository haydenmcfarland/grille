# frozen_string_literal: true

require_relative '../../../lib/vue/single_file_component'
require_relative '../../../lib/vue/inline_template_component'

module Grille
  module ComponentImporter
    mattr_accessor :component_names, default: {}
    mattr_accessor :mixin_names, default: {}

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

    def vuetify
      <<-JS
      import Vuetify from "vuetify";
      Vue.use(Vuetify);
      JS
    end

    def call
      components = Grille::Components::Base.descendants.map do |klass|
        grille_component = klass.new

        mixins = klass.grille_ancestors.map { |a| mixin_name(a) }.compact

        component_string = grille_component.render
        if mixins.present?
          mixin_imports = klass.grille_ancestors.map do |k|
            "import #{mixin_name(k)} from '#{k.mixins_path}';"
          end.join("\n")

          # FIXME: add mixin logic
        end

        name = component_name(klass)

        dir = Rails.root.join('tmp/grille')
        Dir.mkdir(dir) unless File.directory?(dir)
        file_path = dir.join("#{name}.vue")
        File.open(file_path, 'w+') do |f|
          f.write(component_string)
        end
        <<-JS
        const #{name} = () => import("#{file_path}");
        Vue.component('#{name}', #{name})
        JS
      end.join("\n")

      [vuetify, components].join("\n")
    end
  end
end
