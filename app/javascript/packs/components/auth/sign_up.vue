<template>
  <v-container>
    <v-form @submit.prevent="handleSignUp" v-model="valid">
      <v-text-field
        name="firstMame"
        label="First Name"
        v-model="firstName"
        required
      />
      <v-text-field
        name="lastName"
        label="Last Name"
        v-model="lastName"
        required
      />
      <v-text-field
        name="email"
        label="E-mail"
        v-model="email"
        :rules="emailRules"
        required
      />
      <v-text-field
        name="password"
        label="Password"
        v-model="password"
        type="password"
        :rules="passwordRules"
        required
      />
      <v-text-field
        name="confirm_password"
        label="Confirm Password"
        v-model="password_confirmation"
        type="password"
        :rules="passwordConfirmationRules"
        required
      />
      <v-card-actions>
        <v-btn type="submit" primary large block :disabled="!valid"
          >Register</v-btn
        >
      </v-card-actions>
    </v-form>
  </v-container>
</template>

<script>
import signUp from "../../mutations/sign_up";
import { AUTH_TOKEN_KEY, USERNAME_KEY } from "../../config/constants";
import { mapMutations } from "vuex";
import Vue from "vue";

const passwordRules = [
  v => !!v || "Password is required",
  v => v.length > 10 || "Password must be greater than 10 characters"
];

export default {
  name: "Signup",
  data() {
    return {
      valid: false,
      email: "",
      emailRules: [
        v => !!v || "E-mail is required",
        v =>
          /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(v) ||
          "E-mail must be valid"
      ],
      password: "",
      passwordRules: passwordRules,
      password_confirmation: "",
      passwordConfirmationRules: [
        v =>
          this.password == this.password_confirmation || "Passwords must match"
      ].concat(passwordRules),
      firstName: "",
      lastName: "",
    };
  },
  methods: {
    ...mapMutations(["signIn"]),
    handleSignUp() {
      signUp({
        apollo: this.$apollo,
        ...{
          password: this.password,
          email: this.email,
          firstName: this.firstName,
          lastName: this.lastName
        }
      })
        .then(response => {
          if (response.data.signUp) {
            const user = response.data.signUp.user;

            // update vuex
            this.signIn(user);

            // set localStorage items
            localStorage.setItem(AUTH_TOKEN_KEY, user.token);
            localStorage.setItem(USERNAME_KEY, user.email);

            this.$router.go("/");
          }
        })
        .catch(error => {
          this.errors = [error];
        });
    }
  }
};
</script>
