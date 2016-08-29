'use strict'

databaseAdapter = require '../database_adapter'
db = databaseAdapter.getDB()

analyticsController =

  getUser: (req, res) ->
    uuid = req.params.uuid
    db = databaseAdapter.getDB()
    return db.collection('analytics').findOne {uuid: uuid}, (err, result) ->
      if result
        res.status(200).send true
      else
        res.status(200).send false

  getAnalytics: (req, res) ->
    db = databaseAdapter.getDB()
    return db.collection('analytics').find().toArray (err, result) ->
      res.status(200).send result

  postAnalytics: (req, res) ->
    document = req.body
    document.date = new Date
    db.collection('analytics').insert document, (err, result) ->
      res.status(200).send "Successful"

  postTimeAnalytics: (req, res) ->
    document = req.body
    document.date = new Date
    db.collection('analyticstimes').insert document, (err, result) ->
      res.status(200).send "Successful"

  getGeoFreq: (req, res) ->
    db = databaseAdapter.getDB()
    return db.collection('analytics').aggregate [
      {
        "$group": {
           "_id": "$geolocationinfo.country_code",
           "count": {"$sum": 1}
        }
      }
    ], (err, result) ->
      gChartsObject = {cols: [{label: 'Country', type: 'string'}, {label: 'Sessions', type: 'number'}], rows: []}

      for obj in result
        console.log obj
        gChartsObject['rows'].push({c: [{v: obj["_id"]}, {v: obj["count"]}]})
      res.status(200).send gChartsObject

  getSessions: (req, res) ->
    db = databaseAdapter.getDB()
    return db.collection('analytics').aggregate [
      {
        "$lookup": {
          "from": "analyticstimes",
          "localField": "uuid",
          "foreignField": "uuid",
          "as": "pagemetrics"
        }
      },
      {
        "$group": {
          "_id": "$geolocationinfo.country_name",
          "sessionuids": {$addToSet: "$uuid"},
          "pagetime": {$push: "$pagemetrics.timeonpage"},
          "clicks": {$push: "$pagemetrics.numofclicks"}
        }
      }
    ], (err, result) ->
      console.log result
      res.status(200).send result

  getNumSessions: (req, res) ->
    db = databaseAdapter.getDB()
    return db.collection('analytics').aggregate [
      {
        "$group": {
          "_id": {$dayOfYear: "$date"}
          "count": {"$sum": 1}
          "session-uids": {$addToSet: "$uuid"}
        }
      }
    ], (err, result) ->
      res.status(200).send result

module.exports = analyticsController
