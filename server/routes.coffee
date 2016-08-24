"use strict"
testController = require './controllers/test_controller'
feedbackController = require './controllers/feedback_controller'

module.exports = (app, router) ->
  app.use "/api/v1", router

  app.get "/", (req, res) ->
    res.status(200).send "omg-css API"

  # Middleware for router
  router.use (req, res, next)->
    # visualize requests in terminal
    console.log('Making a ' + req.method + ' request to ' + req.url)
    next()

  # Feedback routes
  router.post "/feedback", (req, res) ->
    feedbackController.postFeedback(req, res)

  router.get "/feedback", (req, res) ->
    feedbackController.getFeedbacks(req, res)

  router.get "/feedback/page/:page", (req, res) ->
    feedbackController.getPageFeedback(req, res)

  router.get "/feedback/:feedback_id", (req, res) ->
    feedbackController.getFeedback(req, res)

  router.get "/ip", (req, res) ->
    ip = req.headers['x-forwarded-for'] ||
         req.connection.remoteAddress ||
         req.socket.remoteAddress ||
         req.connection.socket.remoteAddress;
    res.status(200).send ip

  # Test Route
  router.get "/test", (req, res) ->
    testController.get(req, res)

  router.post "/test", (req, res) ->
    testController.post(req, res)

  #router.get "/test/:test_id", (req, res) ->
    #testController.getTest(req, res)


