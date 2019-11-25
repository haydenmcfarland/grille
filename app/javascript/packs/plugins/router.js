import Vue from 'vue'
import Router from 'vue-router'
import Signin from '../../signin.vue'
import Signup from '../../signup.vue'
Vue.use(Router)

export default new Router({
    base: process.env.BASE_URL,
    routes: [
        {
            path: "/",
        },
        {
            path: "/signin",
            name: "signin",
            component: Signin,
        },
        {
            path: "/signup",
            name: "signup",
            component: Signup,
        }
    ],
})