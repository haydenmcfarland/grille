# grille (gem / heavy WIP)
Rails engine that utilizes VueJS and GraphQl to create a generalized grid component/interface

## Goal

- create gem that provides user authentication and grid ui for viewing model data
- provide permission system to protect model CRUD operations
- have a simple interface for extending the base application and grid features

## Info

- uses `devise` and `devise-jwt` for JWT token based authentication with user model
- leverages `graphql` for model CRUD operation interface
- components made using `VueJS`, `Vuetify`, and `agGrid`

![](https://i.imgur.com/pI3dW9C.png)

## TODO

- DRY
- begin adding specs for regression testing and future features
- add permission system (add to jwt payload?)
- create npm package for Grid component
- remove unused files (files from generators)

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
rake grille:webpacker:grille_prepare
```

Currently there are issues with the sassLoader.
Add the following to your `webpack/environment.js`:

```javascript
const sassLoader = environment.loaders.get('sass')
const sassLoaderConfig = sassLoader.use.find(function(element) {
    return element.loader == 'sass-loader'
})

const options = sassLoaderConfig.options
options.implementation = require('sass')
```

Modify `config/webpacker/loaders/vue.js` to the include the following rules:

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
          // Requires sass-loader@^7.0.0
          options: {
            implementation: require('sass'),
            fiber: require('fibers'),
            indentedSyntax: true // optional
          },
          // Requires sass-loader@^8.0.0
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

Create a `grille.js.erb` file in `app/javascript/packs/` and utilize
`Grille.javascript` helper to import desired components.

```javascript
import "<%= Grille.javascript('application.js') %>";
```
