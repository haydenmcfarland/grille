<template>
  <v-app-bar app>
    <v-toolbar-title>
      <router-link to="/">
        <v-btn icon>
          <v-icon>mdi-home</v-icon>
        </v-btn>
      </router-link>
    </v-toolbar-title>
    <v-spacer></v-spacer>
    <div v-if="signedIn">
      <v-menu offset-y auto>
        <template v-slot:activator="{ on }">
          <v-btn v-on="on">
            <v-icon>mdi-menu</v-icon>
          </v-btn>
        </template>
        <v-list>
          <!-- FIXME: this should be its own component & generalize more -->
          <v-list-item v-for="action in actions" :key="action.id">
            <component
              :is="action.component"
              v-bind="action.props"
              @click.prevent="action.handler"
            >
              <v-btn left text>
                <v-icon>{{ action.icon }}</v-icon>
                {{ action.label && action.label() }}
              </v-btn>
            </component>
          </v-list-item>
          <v-list-item>
            <v-switch left v-model="goDark" label="DARK MODE"> </v-switch>
          </v-list-item>
        </v-list>
      </v-menu>
    </div>
  </v-app-bar>
</template>

<script>
import Vue from "vue";
import Vuetify from "vuetify";
Vue.use(Vuetify);

import signOut from "../mutations/signOut";
import { mapMutations } from "vuex";

export default {
  created() {
    this.$vuetify.theme.dark = false;
  },
  data() {
    return {
      actions: [
        {
          id: "logout",
          props: { href: "#", "v-on:click": "handleSignOut()" },
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
        },
        {
          id: "tests",
          props: { to: "/tests" },
          icon: "mdi-account",
          label: () => "Tests",
          component: "router-link"
        },
      ],
      goDark: this.darkMode()
    };
  },
  watch: {
    goDark: {
      handler: function(newValue) {
        // mark dark mode change persistent
        this.toggleDarkMode(newValue);

        // dynamically change theme
        this.$vuetify.theme.dark = newValue;
      },
      deep: true
    }
  },
  methods: {
    ...mapMutations(["clearUser"]),
    handleSignOut() {
      signOut({
        apollo: this.$apollo
      })
        .then(response => {
          if (response.data.signOut.success) {
            // update vuex
            this.clearUser();

            // clear localStorage items
            localStorage.clear();
            this.$router.go("/redirect?=signin");
          }
        })
        .catch(error => {
          this.errors = [error];
        });
    },
  }
};
</script>

<style scoped>
a {
  text-decoration: none;
}
</style>
