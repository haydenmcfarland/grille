import Vue from "vue";
import Router from "vue-router";
Vue.use(Router);

// dynamically load pages and assign routes based on component name
const components = require.context("../components/pages", true, /^.*\.vue$/);
const pages = components.keys().map(function(componentPath) {
  // assume PascalCase convention
  let componentName = componentPath.split("/").pop().split('.')[0];

  return {
    component: components(componentPath).default,
    path: '/' + componentName.toLowerCase(),
    name: componentName
  };
});

const redirect = {
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
    } else {
      return { path: "/home" };
    }
  }
};

const routes = pages.concat(redirect)

const router = new Router({
  base: process.env.BASE_URL,
  mode: "history",
  routes: routes
});

const userPathNames = ["SignIn", "SignUp"];
router.beforeEach((to, from, next) => {
  Vue.prototype.$Progress.finish(0);
  if (to.meta.progress !== undefined) {
    let meta = to.meta.progress;
    // parse meta tags
    Vue.prototype.$Progress.parseMeta(meta);
  }

  Vue.prototype.$Progress.start();

  let loggedIn = !!localStorage.authToken
  let registrationPath = userPathNames.includes(to.name);
  if (loggedIn && registrationPath) next('/home');
  else if (loggedIn && !registrationPath) next();
  else if (!userPathNames.includes(to.name)) next("/signin");
  else next();
});

router.afterEach((_to, _from) => {
  Vue.prototype.$Progress.finish();
});

export default router;
