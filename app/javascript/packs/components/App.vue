<template>
  <v-app id="app" :dark="setTheme">
    <Navbar />
    <v-content>
      <v-container fluid class="full-height">
        <v-row justify="center" class="fill-height">
          <vue-progress-bar></vue-progress-bar>
          <router-view/>
        </v-row>
      </v-container>
    </v-content>
    <Footer />
  </v-app>
</template>

<script>
import Vue from "vue";
import Vuetify from "vuetify";
Vue.use(Vuetify);

import "images/logo.svg";
import Navbar from "./Navbar.vue.erb";
import Footer from "./Footer.vue";

export default {
  components: {
    Navbar,
    Footer
  }
};
</script>

<style scoped>
.grille {
  height: calc(100vh - 270px); /* Adjust 270px to suits your needs */
  overflow-y: auto;
}
</style>