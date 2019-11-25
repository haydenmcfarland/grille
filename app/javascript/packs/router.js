import Vue from 'vue'
import Router from 'vue-router'
import Signin from '../Signin.vue'
Vue.use(Router)

export default new Router({
    base: process.env.BASE_URL,
    routes: [
        {
            path: "/",
        },
        {
            path: "/signin",
            name: "Signin",
            component: Signin,
        }
    ],
})