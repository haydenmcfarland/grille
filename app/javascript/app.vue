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
        <div v-if="!signedIn()">
            <router-link to="/signin">
                <v-btn icon>
                    <v-icon>mdi-account-arrow-right</v-icon>
                </v-btn>
            </router-link>
        </div>
        <div v-else>
            <v-menu offset-y>
                <template v-slot:activator="{ on }">
                    <v-btn v-on="on">
                        User
                    </v-btn>
                </template>
                <v-list>
                    <v-list-item>
                        <v-switch v-model="goDark"></v-switch>
                        <a href="#" @click.prevent="signOut">
                            <v-btn icon>
                                <v-icon>mdi-account-off</v-icon>
                            </v-btn>
                        </a>
                    </v-list-item>
                </v-list>
            </v-menu>
        </div>
    </v-app-bar>
    <v-content>
        <v-container fluid>
            <v-row justify="center">
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
import Vue from 'vue'
import Vuetify from 'vuetify'
Vue.use(Vuetify)

import 'images/logo.svg'

export default {
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
        signedIn() {
            return localStorage.signedIn
        },
        signOut() {
            this.$http.secured.delete('/signin')
                .then(response => {
                    delete localStorage.csrf
                    delete localStorage.signedIn
                    this.$router.replace('/')
                })
        }
    }
}
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
