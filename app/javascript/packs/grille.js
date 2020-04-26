import Vue from "vue";

// vuex
import Vuex from 'vuex';
Vue.use(Vuex)

// progress bar
import VueProgressBar from "vue-progressbar";
import { progressBarConfig } from "./config/progress_bar";
Vue.use(VueProgressBar, progressBarConfig);

// graphql
import apolloProvider from "./plugins/apollo";

// toast
import VuetifyToast from "vuetify-toast-snackbar";
import { toastConfig } from "./config/toast";
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

// application mixins
import SettingsMixin from './mixins/settings';
Vue.mixin(SettingsMixin)

// vuex store
import createStore from './store/base_store';

export {
  Vue,
  vuetify,
  router,
  apolloProvider,
  createStore,
}
