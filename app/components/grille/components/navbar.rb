# frozen_string_literal: true

module Grille
  module Components
    class Navbar < Base
      COMPONENT_PATH = JS_PATH.join('components/Navbar.vue.erb')

      def render(template = File.read(COMPONENT_PATH))
        super(template)
      end

      def actions
        default_actions
      end

      def default_actions
        <<-JS
        {
          id: "logout",
          props: { href: "#" },
          icon: "mdi-account-off",
          label: () => this.username,
          component: "a",
          handler: this.handleSignOut
        },
        {
          id: "users",
          props: { to: "/users" },
          icon: "mdi-account",
          label: () => "Users",
          component: "router-link"
        }
        JS
      end
    end
  end
end
