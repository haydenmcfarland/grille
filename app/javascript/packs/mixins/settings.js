import _isEmpty from "lodash/isEmpty";
import { AUTH_TOKEN_KEY } from "../config/constants";
import { mapGetters } from "vuex";

function authTokenExists() {
  const token = localStorage.getItem(AUTH_TOKEN_KEY);
  return token !== "" && token !== undefined && token !== null;
}

export default {
  computed: {
    ...mapGetters(["user"]),
    signedIn() {
      return !_isEmpty(this.user) && authTokenExists();
    },
    username() {
      if (!this.signedIn) return "";
      return `${this.user.email}`.toUpperCase();
    },
    setTheme() {
      this.$vuetify.theme.dark = this.darkMode();
    },
  },
  methods: {
    toggleDarkMode(value) {
      localStorage.darkMode = !!value
    },
    darkMode() {
      return localStorage.darkMode == 'true'
    }
  }
};
