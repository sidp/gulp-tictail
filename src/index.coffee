_ = require 'lodash'
express = require 'express'
util = require 'gulp-util'

storefront = require './storefront'


module.exports =
  serve: (config = {}) ->
    defaults =
      port: 5555
      dist: './dist'
      src: './src'
      store_id: 't'

    config = _.assign defaults, config

    app = express()
    app.use express.static config.dist
    storefront.set 'store_id', config.store_id
    views = storefront.get 'views'
    views.push config.src
    storefront.set 'views', views
    app.use storefront
    app.listen config.port, -> util.log "Serving your awesome theme at http://localhost:#{config.port}/"
