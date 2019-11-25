import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue'
import App from '../app.vue'
import vuetify from './plugins/vuetify'
import VueAxios from 'vue-axios'
import { securedAxiosInstance, plainAxiosInstance } from './plugins/axios'
import router from './plugins/router'

Vue.use(TurbolinksAdapter)
Vue.use(vuetify)
Vue.use(VueAxios, {
  secured: securedAxiosInstance,
  plain: plainAxiosInstance
})

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    vuetify,
    router,
    render: h => h(App),
  }).$mount()
  document.body.appendChild(app.$el)
})