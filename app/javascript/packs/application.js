// rails
require("@rails/ujs").start();
require("@rails/activestorage").start();

import "initializers/polyfills";
import "initializers/turbolinks";

import Vue from "vue";

import TurbolinksAdapter from "vue-turbolinks";
Vue.use(TurbolinksAdapter);

// progress bar
import VueProgressBar from "vue-progressbar";
import { progressBarConfig } from "./plugins/config/progress_bar";
Vue.use(VueProgressBar, progressBarConfig);

// graphql
import apolloProvider from "./plugins/apollo";

// toast
import VuetifyToast from "vuetify-toast-snackbar";
import { toastConfig } from "./plugins/config/toast";
Vue.use(VuetifyToast, toastConfig);

// vuetify
import vuetify from "./plugins/vuetify";
Vue.use(vuetify);

// axios
import { securedAxiosInstance, plainAxiosInstance } from "./plugins/axios";
import VueAxios from "vue-axios";
Vue.use(VueAxios, {
  secured: securedAxiosInstance,
  plain: plainAxiosInstance
});

// router
import router from "./plugins/router";

// main application component
import App from "./components/app.vue";

document.addEventListener("turbolinks:load", () => {
  const app = new Vue({
    vuetify,
    router,
    apolloProvider,
    render: h => h(App)
  }).$mount();
  document.body.appendChild(app.$el);
});
