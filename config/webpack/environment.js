const { environment } = require("@rails/webpacker");
const erb = require("./loaders/erb");
const { VueLoaderPlugin } = require("vue-loader");
const vue = require("./loaders/vue");

environment.plugins.prepend("VueLoaderPlugin", new VueLoaderPlugin());
environment.loaders.prepend("vue", vue);

const sassLoader = environment.loaders.get("sass");
const sassLoaderConfig = sassLoader.use.find(function(element) {
  return element.loader == "sass-loader";
});

const options = sassLoaderConfig.options;
options.implementation = require("sass");
environment.loaders.prepend("erb", {
  test: /\.erb$/,
  enforce: "pre",
  exclude: /node_modules/,
  use: [
    {
      loader: "rails-erb-loader",
      options: {
        runner:
          (/^win/.test(process.platform) ? "ruby " : "") +
          "bundle exec rails runner", // <- here
      },
    },
  ],
});
module.exports = environment;
