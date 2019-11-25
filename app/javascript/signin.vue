<!-- recordstore-frontend/src/components/Signin.vue -->

<template>
<v-container>
    <v-alert>
        {{ error }}
    </v-alert>
    <v-form @submit.prevent="signin">
        <v-text-field name="Email" label="Email"></v-text-field>
        <v-text-field name="Password" label="Password" type="password"></v-text-field>
        <v-card-actions>
            <v-btn type="submit" primary large block>Login</v-btn>
        </v-card-actions>
    </v-form>
</v-container>
</template>

<script>
export default {
    name: 'Signin',
    data() {
        return {
            email: '',
            password: '',
            error: ''
        }
    },
    created() {
        this.checkSignedIn()
    },
    updated() {
        this.checkSignedIn()
    },
    methods: {
        signin() {
            this.$http.plain.post('/signin', {
                    email: this.email,
                    password: this.password
                })
                .then(response => this.signinSuccessful(response))
                .catch(error => this.signinFailed(error))
        },
        signinSuccessful(response) {
            if (!response.data.csrf) {
                this.signinFailed(response)
                return
            }
            localStorage.csrf = response.data.csrf
            localStorage.signedIn = true
            this.error = ''
            this.$router.replace('/records')
        },
        signinFailed(error) {
            this.error = (error.response && error.response.data && error.response.data.error) || ''
            delete localStorage.csrf
            delete localStorage.signedIn
        },
        checkSignedIn() {
            if (localStorage.signedIn) {
                this.$router.replace('/records')
            }
        },
    }
}
</script>
