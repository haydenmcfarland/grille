<template>
  <v-app id="app" :dark="setTheme">
    <Navbar/>
    <v-content>
      <v-container fluid>
        <v-row justify="center">
          <vue-progress-bar></vue-progress-bar>
          <router-view />
        </v-row>
      </v-container>
    </v-content>
    <Footer/>
  </v-app>
</template>

<script>
import Vue from "vue";
import Vuetify from "vuetify";
Vue.use(Vuetify);

import "images/logo.svg";
import Navbar from "./Navbar.vue";
import Footer from "./Footer.vue";

export default {
  components: {
    Navbar,
    Footer
  }
};
</script>
