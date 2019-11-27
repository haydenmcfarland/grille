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

router.beforeEach((to, from, next) => {
    Vue.prototype.$Progress.finish(0);
    if (to.meta.progress !== undefined) {
        let meta = to.meta.progress
        // parse meta tags
        Vue.prototype.$Progress.parseMeta(meta)
      }

    Vue.prototype.$Progress.start();
    if (localStorage.signedIn) next(to);
    else if (!localStorage.signedIn && !userPathNames.includes(to.name)) next('/signin');
    else next()
});

router.afterEach((_to, _from) => {
    Vue.prototype.$Progress.finish()
})

export default router