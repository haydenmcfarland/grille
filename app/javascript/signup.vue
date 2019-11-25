<template>
<v-container>
    <v-form @submit.prevent="signup">
        <v-text-field name="Email" label="Email"/>
        <v-text-field name="Password" label="Password" type="password" data-vv-name="pass"/>
        <v-text-field name="ConfirmPassword" label="Confirm Password" type="password"/>
        <v-card-actions>
            <v-btn type="submit" primary large block>Register</v-btn>
        </v-card-actions>
    </v-form>
</v-container>
</template>

<script>
export default {
    name: 'Signup',
    data() {
        return {
            email: '',
            password: '',
            password_confirmation: '',
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
            this.$router.replace('/records')
        },
        signupFailed() {
            delete localStorage.csrf
            delete localStorage.signedIn
        },
        checkedSignedIn() {
            if (localStorage.signedIn) {
                this.$router.replace('/records')
            }
        }
    }
}
</script>
