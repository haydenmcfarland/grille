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
          <v-list-item>
            <a href="#" @click.prevent="handleSignOut">
              <v-btn left text>
                <v-icon>mdi-account-off</v-icon> {{ username }}
              </v-btn>
            </a>
          </v-list-item>
          <v-list-item>
            <router-link to="/users">
              <v-btn left text> <v-icon>mdi-account</v-icon> Users </v-btn>
            </router-link>
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

import signOut from "../mutations/sign_out";
import { mapMutations } from "vuex";

export default {
  created() {
    this.$vuetify.theme.dark = false;
  },
  data() {
    return {
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
    }
  }
};
</script>

<style scoped>
a {
  text-decoration: none;
}
</style>
