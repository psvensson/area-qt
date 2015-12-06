expect    = require('chai').expect
QuadTree  = require('../lib/QuadTree')

describe 'QuadTree Tests', ->
  # setup
  qt = new QuadTree({x:-100, y:-100, width: 100, height: 200}, 200)
  r1 = {x:0, y:0, width: 10, height: -10}
  o1 = {x:0, y:0, width: 10, height: -10, id:17}

  # tests
  it 'should be able to insert and retrieve a rect', (done)->
    qt.insert(o1)
    test = qt.retrieve(r1)[0]
    expect(test.id).to.equal(o1.id)
    done()

  it 'should be able to insert and retrieve a number of rects that is larger than maxobject', (done)->
    testarr = []
    succeed = false
    for i in [1..500]
      x = parseInt(Math.random()*100)
      y = parseInt(Math.random()*100)
      o = {x: 0, y: y, width: 10, height: 10, id:i}
      r = {x: 0, y: y, width: 10, height: 10}
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