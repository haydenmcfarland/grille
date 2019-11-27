<template>
<v-container>
    <v-form @submit.prevent="signin" v-model="valid">
        <v-text-field name="email" label="E-mail" v-model="email" :rules="emailRules" required />
        <v-text-field name="password" label="Password" v-model="password" type="password" :rules="passwordRules" required />
        <v-card-actions>
            <v-btn type="submit" primary large block :disabled="!valid">Login</v-btn>
        </v-card-actions>
    </v-form>
</v-container>
</template>

<script>
export default {
    name: 'Signin',
    data() {
        return {
            valid: false,
            email: '',
            emailRules: [
              (v) => !!v || 'E-mail is required',
              (v) => /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(v) ||
              'E-mail must be valid'
            ],
            password: '',
            passwordRules: [
              (v) => !!v || 'Password is required',
              (v) => v.length > 10 ||
              'Password must be greater than 10 characters'
            ],
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
                .catch(error => this.signinFailed())
        },
        signinSuccessful(response) {
            console.log(response)
            if (!response.data.csrf) {
                this.signinFailed(response)
                return
            }
            localStorage.csrf = response.data.csrf
            localStorage.signedIn = true
            this.$router.go('/')
        },
        signinFailed() {
            delete localStorage.csrf
            delete localStorage.signedIn
        },
        checkSignedIn() {
            if (localStorage.signedIn) {
                this.$router.go('/')
            }
        },
    }
}
</script>
