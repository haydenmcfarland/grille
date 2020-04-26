// config/webpack/custom.js
module.exports = {
  resolve: {
    alias: {
      vue: 'vue/dist/vue.js',
    }
  }
}

// config/webpack/environment.js
const { environment } = require('@rails/webpacker')
const customConfig = require('./custom')

// Set nested object prop using path notation
environment.config.set('resolve.extensions', ['.foo', '.bar'])
environment.config.set('output.filename', '[name].js')

// Merge custom config
environment.config.merge(customConfig)
environment.config.merge({ devtool: 'none' })

// Delete a property
environment.config.delete('output.chunkFilename')

module.exports = environment