<template>
  <div id="app">
    <b-navbar>
        <template slot="brand">
            <b-navbar-item tag="router-link" :to="{ path: '/' }">
                <img src="~/images/logo.svg">
            </b-navbar-item>
            <b-navbar-item href="https://haydenmcfarland.me">
            Home
            </b-navbar-item>
        </template>
        <template slot="start">
            <b-navbar-item href="#">
                Toggle Dark Mode
            </b-navbar-item>
        </template>

        <template slot="end">
            <b-navbar-item tag="div">
                <div class="buttons">
                    <a class="button is-primary">
                        <strong>Sign up</strong>
                    </a>
                    <a class="button is-light">
                        Log in
                    </a>
                </div>
            </b-navbar-item>
        </template>
    </b-navbar>
    <Grid></Grid>
  </div>
</template>

<script>

import Grid from './grid.vue'
import 'images/logo.svg'

export default {
  components: {
    Grid
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
