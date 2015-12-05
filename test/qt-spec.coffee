expect    = require('chai').expect
QuadTree  = require('../lib/QuadTree')

describe 'QuadTree Tests', ->
  # setup
  qt = new QuadTree({x:-100, y:-100, width: 200, height: 200}, 10)
  r1 = {x:-1, y:-1, width: 10, height: -10}

# tests
  it 'should be able to insert and retrieve a rect', (done)->
    qt.insert(r1)
    test = qt.retrieve(r1)
    expect(test).to.equal(r1)
    done()