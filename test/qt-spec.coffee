expect    = require('chai').expect
QuadTree  = require('../lib/QuadTree')

describe 'QuadTree Tests', ->
  # setup
  qt = new QuadTree({x:-100, y:-100, width: 200, height: 200}, 5)
  r1 = {x:0, y:0, width: 10, height: 10}
  o1 = {x:0, y:0, width: 10, height: 10, id:17}

  # tests
  it 'should be able to insert and retrieve an object', (done)->
    qt.insert(o1)
    test = qt.retrieve(r1)[0]
    expect(test.id).to.equal(o1.id)
    done()

  it 'should be able to insert and retrieve a number of objects that is larger than maxobject', (done)->
    testarr = []
    succeed = false
    for i in [1..20]
      x = parseInt(Math.random()*100)
      y = parseInt(Math.random()*100)
      o = {x: x, y: y, width: 10, height: 10, id:i}
      r = {x: x, y: y, width: 10, height: 10}
      testarr.push {o: o, r: r}
      qt.insert(o)
    testarr.forEach (test) ->
      result = qt.retrieve(test.r)
      #console.log '--- test '+test.r.x+','+test.r.y+' id '+test.o.id+' got back '+result.length+' objects'
      result.forEach (res) =>
        #console.log 'checking if '+res.id+' == '+test.o.id
        if res.id == test.o.id then succeed = true
    expect(succeed).to.equal(true)
    done()

  it 'should be able to insert and remove an object', (done)->
    r2 = {x:5, y:2, width: 10, height: 10}
    o2 = {x:5, y:2, width: 10, height: 10, id:4711}
    qt.insert(o2)
    qt.remove(r2)
    result = qt.retrieve(r2)
    expect(result.length).to.equal(0)
    done()