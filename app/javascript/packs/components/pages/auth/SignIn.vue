<template>
  <v-container>
    <v-form @submit.prevent="handleSignIn" v-model="valid">
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
      <v-card-actions>
        <v-btn type="submit" primary large block :disabled="!valid"
          >Login</v-btn
        >
      </v-card-actions>
    </v-form>
  </v-container>
</template>

<script>
import _get from "lodash/get";
import signIn from "../../../mutations/signIn";
import { AUTH_TOKEN_KEY, USERNAME_KEY } from "../../../config/constants";
import { mapMutations } from "vuex";
import Vue from "vue";

export default {
  name: "SignIn",
  data() {
    return {
      valid: false,
      error: {},
      email: "",
      emailRules: [
        v => !!v || "E-mail is required",
        v =>
          /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(v) ||
          "E-mail must be valid"
      ],
      password: "",
      passwordRules: [
        v => !!v || "Password is required",
        v => v.length > 10 || "Password must be greater than 10 characters"
      ]
    };
  },
  created() {},
  updated() {},
  methods: {
    ...mapMutations(["signIn"]),
    handleSignIn() {
      signIn({
        apollo: this.$apollo,
        ...{ password: this.password, email: this.email }
      })
        .then(response => {
          let data = _get(response, "data.signIn", {});
          if (!data.success) {
            return Vue.prototype.$toast.error('Invalid email/password');
          }

          if (data.result) {
            const user = JSON.parse(data.result);

            // update vuex
            this.signIn(user);

            // set localStorage items
            localStorage.setItem(AUTH_TOKEN_KEY, user.token);
            localStorage.setItem(USERNAME_KEY, user.email);

            this.$router.push("/");
          }
        })
        .catch(error => {
          this.errors = [error];
        });
    }
  }
};
</script>
