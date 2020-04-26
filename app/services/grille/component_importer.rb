# frozen_string_literal: true

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

    def vuetify_js
      <<-JS
      import Vuetify from "vuetify";
      Vue.use(Vuetify);
      JS
    end

    def create_temporary_component_file(name, component_string)
      dir = Rails.root.join('tmp/grille')
      Dir.mkdir(dir) unless File.directory?(dir)
      file_path = dir.join("#{name}.vue")
      File.open(file_path, 'w+') do |f|
        f.write(component_string)
      end
      file_path
    end

    def import_js(name, file_path)
      "import #{name} from \"#{file_path}\";"
    end

    def lazy_import_js(name, file_path)
      "const #{name} = () => import(\"#{file_path}\");"
    end

    def lazy_import_component_js(name, file_path)
      <<-JS
      #{lazy_import_js(name, file_path)}
      Vue.component('#{name}', #{name})
      JS
    end

    def inject_mixins(klass)
      component_string = klass.new.render
      mixins = klass.grille_ancestors.map { |a| mixin_name(a) }.compact
      return component_string if mixins.blank?

      imports = klass.grille_ancestors.map do |k|
        import_js(mixin_name(k), k.mixins_path)
      end.join("\n")

      # FIXME: add logic for prexisting mixins
      component_string.sub!('<script>', "<script>\n#{imports}")
      js = ",\n  mixins: [#{mixins.join(', ')}]\n};\n</script>"
      component_string.sub!(/(,)?}(;)?\n<\/script>/, js)
      component_string
    end

    def call
      components = Grille::Components::Base.descendants.map do |klass|
        component_string = inject_mixins(klass)
        name = component_name(klass)
        file_path = create_temporary_component_file(name, component_string)
        lazy_import_component_js(name, file_path)
      end.join("\n")

      [vuetify_js, components].join("\n")
    end
  end
end
