# Load global before/after

db        = require '../utils'
request   = require 'superagent'
prefix    = require 'superagent-prefix'
chai      = require 'chai'
assert    = chai.assert
expect    = chai.expect
should    = chai.should

prefix = prefix(':3000/api/v1')

beforeEach (done) ->
  db.collection('feedback')
      .insert {
        name: "Feedback"
      }, (err, result) ->
        if err
          console.log("Could not prepare feedback collection")
        done()

describe 'Model: Feedback', ->
  it 'should be able to get feedbacks', (done)->
    request
    .get('/feedback').use prefix
    .end (err, res) ->
      expect(err).to.equal null
      expect(res.body.length).to.equal 1
      done()

  it 'should fail', (done)->
    throw new Error "fail"

  it 'should be able to add feedback', (done)->
    request
    .post('/feedback').use prefix
    .send({page:"test"})
    .end (err, res) ->
      expect(err).to.equal null
      expect(res.text).to.equal "Successful"
      db.collection('feedback').find().toArray (err, result)->
        expect(err).to.equal null
        expect(result.length).to.equal 2
        done()
