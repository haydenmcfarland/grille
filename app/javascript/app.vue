<template>
<v-app id="app" :dark="setTheme">
      <v-app-bar app>
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
                    <div v-if="!signedIn()">
                        ---
                    </div>
                    <div v-else>
                        User
                    </div>
                </v-btn>
            </template>
            <v-list>
              <v-list-item>
                <v-switch v-model="goDark"></v-switch>
                <router-link to="/signin" class="link-grey px-2 no-underline" v-if="!signedIn()">Sign in</router-link>
                <a href="#" @click.prevent="signOut" class="link-grey px-2 no-underline" v-if="signedIn()">Sign out</a>
              </v-list-item>
            </v-list>
          </v-menu>
        </template>
      </v-app-bar>
      <v-content>
        <v-container fluid fill-height>
            <router-view/>
        </v-container>
      </v-content>
    <v-bottom-navigation fixed>
    </v-bottom-navigation>
</v-app>
</template>

<script>
import Grid from './grid.vue'
import Vue from 'vue'
import Vuetify from 'vuetify'
import 'images/logo.svg'
import router from './packs/router'
Vue.use(Vuetify)

export default {
  router,
  components: {
    Grid
  },
  created() {
    this.$vuetify.theme.dark = false;
    this.signedIn();
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
    },
    methods: {
        setError (error, text) {
        this.error = (error.response && error.response.data && error.response.data.error) || text
        },
        signedIn () {
        return localStorage.signedIn
        },
        signOut () {
        this.$http.secured.delete('/signin')
            .then(response => {
            delete localStorage.csrf
            delete localStorage.signedIn
            this.$router.replace('/')
            })
            .catch(error => this.setError(error, 'Cannot sign out'))
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
