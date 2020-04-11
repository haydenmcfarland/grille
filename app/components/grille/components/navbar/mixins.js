export default {
  data() {
    return {
      actions: [
        {
          id: "logout",
          props: { href: "#" },
          icon: "mdi-account-off",
          label: () => "Logout",
          component: "a",
          handler: this.handleSignOut,
        },
        {
          id: "users",
          props: { to: "/users" },
          icon: "mdi-account",
          label: () => "Users",
          component: "router-link",
        },
        {
          id: "projects",
          props: { to: "/projects" },
          icon: "mdi-pencil",
          label: () => "Projects",
          component: "router-link",
        },
      ],
    };
  },
};
