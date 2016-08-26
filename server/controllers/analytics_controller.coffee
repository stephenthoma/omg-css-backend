'use strict'

databaseAdapter = require '../database_adapter'
db = databaseAdapter.getDB()

analyticsController =

  getAnalytics: (req, res) ->
    #db = databaseAdapter.getDB()
    #return db.collection('analytics').find().toArray (err, result) ->
      #res.status(200).send result
    res.status(500).send

  getGeo: (req, res) ->
    mockData = { Countries: [
      ['Country', 'Popularity'],
      ['Germany', 200],
      ['United States', 300],
      ['Brazil', 400],
      ['Canada', 500],
      ['France', 600],
      ['RU', 700]
    ]}

    res.status(200).json(mockData)

  postAnalytics: (req, res) ->
    document = req.body
    res.status(500).send

  postTimeAnalytics: (req, res) ->
    res.status(500).send

module.exports = analyticsController
