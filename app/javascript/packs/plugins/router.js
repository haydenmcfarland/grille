import Vue from "vue";
import Router from "vue-router";
import Signin from "../components/auth/sign_in.vue";
import Signup from "../components/auth/sign_up.vue";
Vue.use(Router);

const router = new Router({
  base: process.env.BASE_URL,
  mode: "history",
  routes: [
    {
      path: "/",
      name: "Redirect",
      redirect: function(to) {
        if (to.query.redirect) {
          // This will clear the ?redirect=<path> from the end URL
          var path = to.query.redirect;
          delete to.query.redirect;
          return {
            path: "/" + path,
            query: to.query
          };
        }
      }
    },
    {
      path: "/signin",
      name: "signin",
      component: Signin
    },
    {
      path: "/signup",
      name: "signup",
      component: Signup
    }
  ]
});

const userPathNames = ["signin", "signup"];

router.beforeEach((to, from, next) => {
  Vue.prototype.$Progress.finish(0);
  if (to.meta.progress !== undefined) {
    let meta = to.meta.progress;
    // parse meta tags
    Vue.prototype.$Progress.parseMeta(meta);
  }

  Vue.prototype.$Progress.start();
  if (localStorage.signedIn) next();
  else if (!userPathNames.includes(to.name)) next("/signin");
  else next();
});

router.afterEach((_to, _from) => {
  Vue.prototype.$Progress.finish();
});

export default router;
