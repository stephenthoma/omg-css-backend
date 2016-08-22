'use strict'

databaseAdapter = require '../database_adapter'
db = databaseAdapter.getDB()

# Stores and retrieves feedback data from the database
feedbackController =

  # a get request that returns all feedback
  getFeedbacks: (req, res) ->
    db = databaseAdapter.getDB()
    return db.collection('feedback').find().toArray (err, result) ->
      res.status(200).send result

  # get feedback for a specific page
  getPageFeedback: (req, res) ->
    page = req.params.page
    db = databaseAdapter.getDB()
    return db.collection('feedback')
      .find
        page: page
      .toArray (err, result) ->
        if err
          res.send err
        res.status(200).send result

  getFeedback: (req,res) ->
    fb_id = req.params.feedback_id
    db = databaseAdapter.getDB()
    return db.collection('feedback')
      .find
        _id: mongo.helper.toObjectID(fb_id)
      .toArray (err, result) ->
        if err
          res.send err
        res.status(200).send result

  # add a feedback document to the collection
  postFeedback: (req, res) ->
    document = req.body
    db.collection('feedback').insert document, (err, result) ->
      res.status(200).send "Successful"

module.exports = feedbackController
