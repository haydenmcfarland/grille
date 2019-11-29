<template>
  <v-container>
    <v-form @submit.prevent="handleSignIn" v-model="valid">
      <v-text-field
        name="email"
        label="E-mail"
        v-model="form.email"
        :rules="emailRules"
        required
      />
      <v-text-field
        name="password"
        label="Password"
        v-model="form.password"
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
import _get from 'lodash/get';
import signIn from '../../mutations/sign_in';
import { AUTH_TOKEN_KEY } from '../../config/constants';
import { mapMutations } from 'vuex';

export default {
  name: "Signin",
  data() {
    return {
      valid: false,
      error:{},
      form: {},
      emailRules: [
        v => !!v || "E-mail is required",
        v =>
          /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(v) ||
          "E-mail must be valid"
      ],
      passwordRules: [
        v => !!v || "Password is required",
        v => v.length > 10 || "Password must be greater than 10 characters"
      ]
    };
  },
  created() {

  },
  updated() {

  },
  methods: {
    ...mapMutations(['signIn']),
    handleSignIn() {
      signIn({
        apollo: this.$apollo,
        ...this.form,
      }).then(response => _get(response, 'data.signIn', {}))
      .then(response => {
        if(response.success) {
          const user = response.user;
          this.signIn(user);
          localStorage.setItem(AUTH_TOKEN_KEY, user.authenticationToken);
          this.$router.push('/');
        } else {
          this.errors = this.errorMessages(response.data.signIn.errors);
        }
      }).catch(error => {
        this.errors = [error];
      });
    },
  },
};
</script>

