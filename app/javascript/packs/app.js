import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue'
import App from '../app.vue'
import vuetify from './plugins/vuetify'
import { securedAxiosInstance, plainAxiosInstance } from './plugins/axios'
import VueAxios from 'vue-axios'
import router from './plugins/router'
import VueProgressBar from 'vue-progressbar'

const options = {
	color: '#7B1FA2',
	failedColor: '#8A2BE2',
	thickness: '5px',
	transition: {
	  speed: '0.2s',
	  opacity: '0.6s',
	  termination: 300
	},
	autoRevert: true,
	location: 'top',
	inverse: false
  }
Vue.use(VueProgressBar, options)

import VuetifyToast from 'vuetify-toast-snackbar'
Vue.use(VuetifyToast, {
	x: 'middle', // default
	y: 'top', // default
	color: 'info', // default
	icon: 'mdi-alert-circle',
	iconColor: '', // default
	classes: [
		'body-2'
	],
	timeout: 3000, // default
	dismissable: true, // default
	multiLine: false, // default
	vertical: false, // default
	queueable: false, // default
	showClose: false, // default
	closeText: '', // default
	closeIcon: 'close', // default
	closeColor: '', // default
	slot: [], //default
	shorts: {
		custom: {
			color: 'purple'
		}
	},
	property: '$toast' // default
})

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