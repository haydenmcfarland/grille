<template>
  <v-app id="app" :dark="setTheme">
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
                <v-btn icon>
                  <v-icon>mdi-account-off</v-icon>
                </v-btn>
              </a>
              <v-label>
                {{ username }}
              </v-label>
            </v-list-item>
            <v-list-item>
              <v-switch v-model="goDark" label="DARK MODE"> </v-switch>
            </v-list-item>
          </v-list>
        </v-menu>
      </div>
    </v-app-bar>
    <v-content>
      <v-container fluid>
        <v-row justify="center">
          <vue-progress-bar></vue-progress-bar>
          <router-view />
        </v-row>
      </v-container>
    </v-content>
    <v-bottom-navigation fixed>
      <img src="~/images/logo.svg" />
    </v-bottom-navigation>
  </v-app>
</template>

<script>
import Vue from "vue";
import Vuetify from "vuetify";
Vue.use(Vuetify);

import "images/logo.svg";

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
p {
  font-size: 2em;
  text-align: center;
}

a {
  text-decoration: none;
}
</style>
