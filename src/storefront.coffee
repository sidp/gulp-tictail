_ = require 'lodash'
Q = require 'q'
express = require 'express'
consolidate = require 'consolidate'
Api = require './api'
transforms = require './transforms'
merge = require 'merge'


api = new Api()

app = express()
app.engine 'mustache', consolidate.mustache
app.set 'view engine', 'mustache'
app.set 'views', './src'
app.disable 'etag'

app.use (req, res, next) ->
  id = 'px8'

  res.promises = []
  store = api.get "stores/#{id}"
  res.promises.push transforms.store store
  res.promises.push transforms.navigation(
    store
    api.get("stores/#{id}/categories")
  )

  next()

app.get '/', (req, res, next) -> next()
app.get '/products', (req, res, next) -> next()
app.get '/product/:slug', (req, res, next) -> next()
app.get '*', (req, res, next) -> next()

app.use (req, res) ->
  # TODO Load partials

  Q.all res.promises
    .then (results) ->
      data = {}
      for result in results
        data = merge.recursive(data, result)
      res.render 'theme', data
    .catch (reason) ->
      console.log reason
      res.status(500)

module.exports = app
