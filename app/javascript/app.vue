<template>
<v-app id="inspire">
    <div>
      <v-toolbar>
        <img src="~/images/logo.svg">
  
        <v-spacer></v-spacer>
  
        <v-toolbar-items>
          <v-btn text>Link 1</v-btn>
          <v-btn text>Link 2</v-btn>
          <v-btn text>Link 3</v-btn>
        </v-toolbar-items>
  
        <template v-if="$vuetify.breakpoint.smAndUp">
          <v-btn icon>
            <v-icon>mdi-export-variant</v-icon>
          </v-btn>
          <v-btn icon>
            <v-icon>mdi-delete-circle</v-icon>
          </v-btn>
          <v-btn icon>
            <v-icon>mdi-plus-circle</v-icon>
          </v-btn>
        </template>
      </v-toolbar>
    <Grid></Grid>
  </div>
</v-app>
</template>

<script>

import Grid from './grid.vue'
import Vue from 'vue'
import Vuetify from 'vuetify'
import 'images/logo.svg'

Vue.use(Vuetify)

export default {
  components: {
    Grid
  },
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
