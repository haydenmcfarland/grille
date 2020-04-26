# grille (heavy WIP)

Rails engine that utilizes Vue and GraphQL to create a generalized grid component/interface and ruby vuejs dsl.

## GOAL

- create gem that provides user authentication and grid ui for viewing model data
- provide permission system to protect model CRUD operations
- have a simple interface for extending the base application and grid features
- provide pagination and infinite scroll grid interfaces
- make components reusable and extendable via webpacker
- determine if reliable replacement for Netzke/ExtJS framework

## INFO

- uses `devise` and `devise-jwt` for JWT token based authentication with user model
- leverages `graphql` for model CRUD operation interface
- components made using `Vue`, `Vuetify`, and `agGrid`

![example](https://github.com/haydenmcfarland/assets/blob/master/images/grille.gif?raw=true)
![example](https://github.com/haydenmcfarland/assets/blob/master/images/grille_simple_auth.gif?raw=true)


## TODO

- DRY + reorganization
- begin adding specs for regression testing and future features
- make permission system more configurable
- allow errors to propagate through UI when logged in
- provide support for predefined component mixins, etc.

## HOW TO USE

Add the following to your `Gemfile`:

``` ruby
gem 'grille', git: 'https://github.com/haydenmcfarland/grille'
```

```
bundle install
```

Run the following rake prep task to install `erb`/`vue` integrations for
webpacker and install yarn packages:

```
rake grille:webpacker:prepare
```
Add the following to your `config/webpack/environment.js`:

```javascript
const sassLoader = environment.loaders.get('sass')
const sassLoaderConfig = sassLoader.use.find(function(element) {
    return element.loader == 'sass-loader'
})

const options = sassLoaderConfig.options
options.implementation = require('sass')
```

Add/Modify `config/webpacker/loaders/vue.js` to the include the following rules:

```javascript
module.exports = {
  test: /\.vue(\.erb)?$/,
  use: [{
    loader: 'vue-loader'
  }],
  rules: [
    {
      test: /\.s(c|a)ss$/,
      use: [
        'vue-style-loader',
        'css-loader',
        {
          loader: 'sass-loader',
          options: {
            implementation: require('sass'),
            sassOptions: {
              fiber: require('fibers'),
              indentedSyntax: true // optional
            },
          },
        },
      ],
    },
  ],
}
```
Add/modify `config/webpacker/loaders/erb.js` to include the following:

```
module.exports = {
  test: /\.erb$/,
  enforce: 'pre',
  exclude: /node_modules/,
  use: [{
    loader: 'rails-erb-loader',
    options: {
      runner: (/^win/.test(process.platform) ? 'ruby ' : '') + 'bin/rails runner'
    }
  }]
}
```

Create a `grille.js.erb` file in `app/javascript/packs/` and utilize
`Grille.javascript` and helper to import desired components.

```javascript
import {
  Vue,
  vuetify,
  router,
  App,
  apolloProvider,
  createStore
} from "<%= Grille.javascript('packs/grille.js') %>";
```

Utilize the `Grille::ComponentImporter` service call to render all grille and extended components:
```javascript

<%= Grille::ComponenterImporter.call %>

// MySickApp derived from App is now available to reference
document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    vuetify,
    router,
    apolloProvider,
    store: createStore(),
    render: h => h(MySickApp)
  }).$mount();
  document.body.appendChild(app.$el);
});
```
# Example Component Extension

## Change actions defined in default Navbar:

Create a new class in the components directory derived from the base grille navbar class:

```ruby
// app/components/navbar.rb
class Navbar < Grille::Components::Navbar; end
```

Create a folder with the same name as the component rb file and define a mixins.js file with desired changes:
```javascript
// app/components/navbar/mixins.js
export default {
  data() {
    return {
      actions: [
        {
          id: "logout",
          props: { href: "#" },
          icon: "mdi-account-off",
          label: () => "Logout",
          component: "a",
          handler: this.handleSignOut,
        },
        {
          id: "users",
          props: { to: "/users" },
          icon: "mdi-account",
          label: () => "Users",
          component: "router-link",
        },
        {
          id: "projects",
          props: { to: "/projects" },
          icon: "mdi-pencil",
          label: () => "Projects",
          component: "router-link",
        },
      ],
    };
  },
};
```
