<template>
<v-container>
    <v-form @submit.prevent="signup" v-model="valid">
        <v-text-field name="email" label="E-mail" v-model="email" :rules="emailRules" required />
        <v-text-field name="password" label="Password" v-model="password" type="password" :rules="passwordRules" required />
        <v-text-field name="confirm_password" label="Confirm Password" v-model="password_confirmation" type="password" :rules="passwordConfirmationRules" required />
        <v-card-actions>
            <v-btn type="submit" primary large block :disabled="!valid">Register</v-btn>
        </v-card-actions>
    </v-form>
</v-container>
</template>

<script>

const passwordRules = [
              v => !!v || 'Password is required',
              v => v.length > 10 ||
              'Password must be greater than 10 characters'
            ]

export default {
    name: 'Signup',
    data() {
        return {
            valid: false,
            email: '',
            emailRules: [
              v => !!v || 'E-mail is required',
              v => /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(v) ||
              'E-mail must be valid'
            ],
            password: '',
            passwordRules: passwordRules,
            password_confirmation: '',
            passwordConfirmationRules: [
                v => this.password == this.password_confirmation ||
                'Passwords must match'
            ].concat(passwordRules)

        }
    },
    created() {
        this.checkedSignedIn()
    },
    updated() {
        this.checkedSignedIn()
    },
    methods: {
        signup() {
            this.$http.plain.post('/signup', {
                    email: this.email,
                    password: this.password,
                    password_confirmation: this.password_confirmation
                })
                .then(response => this.signupSuccessful(response))
                .catch(error => this.signupFailed())
        },
        signupSuccessful(response) {
            if (!response.data.csrf) {
                this.signupFailed(response)
                return
            }

            localStorage.csrf = response.data.csrf
            localStorage.signedIn = true
            this.$router.replace('/')
        },
        signupFailed() {
            delete localStorage.csrf
            delete localStorage.signedIn
        },
        checkedSignedIn() {
            if (localStorage.signedIn) {

                this.$router.replace('/')
            }
        }
    }
}
</script>
