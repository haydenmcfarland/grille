<template>
<v-app id="app" :dark="setTheme">
      <v-toolbar>
        <img src="~/images/logo.svg">
  
        <v-spacer></v-spacer>
  
        <v-toolbar-items>
          <v-btn text>Applications</v-btn>
        </v-toolbar-items>
  
        <template v-if="$vuetify.breakpoint.smAndUp">
          <v-btn icon>
            <v-icon>mdi-plus-circle</v-icon>
          </v-btn>
          <v-menu offset-y>
            <template v-slot:activator="{ on }">
              <v-btn dark v-on="on">
                User
              </v-btn>
            </template>
            <v-list>
              <v-list-item>
                <v-switch v-model="goDark"></v-switch>
              </v-list-item>
            </v-list>
          </v-menu>
        </template>
      </v-toolbar>
      <v-content>
        <v-container fluid fill-height>
            <Header/>
            <router-view/>
        </v-container>
      </v-content>
    <v-bottom-navigation fixed>
    </v-bottom-navigation>
</v-app>
</template>

<script>
import Grid from './grid.vue'
import Header from './Header.vue'
import Vue from 'vue'
import Vuetify from 'vuetify'
import 'images/logo.svg'
import router from './packs/router'
Vue.use(Vuetify)

export default {
  router,
  components: {
    Header,
    Grid
  },
  created() {
    this.$vuetify.theme.dark = false
  },
  data() {
        return {
            goDark: false
        };
    },
    computed: {
        setTheme() {
            if (this.goDark == true) {
                return (this.$vuetify.theme.dark = true);
            } else {
                return (this.$vuetify.theme.dark = false);
            }
        }
    }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

</style>
