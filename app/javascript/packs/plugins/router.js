import Vue from 'vue'
import Router from 'vue-router'
import Signin from '../../signin.vue'
import Signup from '../../signup.vue'
Vue.use(Router)

const router = new Router({
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

const userPathNames = ['signin', 'signup']
const signedIn = () => { localStorage.signedIn }

router.beforeEach((to, _from, next) => {
    if (!signedIn() && !userPathNames.includes(to.name)) next('/signin');
    else next()
});

export default router