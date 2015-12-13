expect    = require('chai').expect
QuadTree  = require('../lib/QuadTree')

describe 'QuadTree Tests', ->
  # setup
  qt = new QuadTree({x:-100, y:-100, width: 200, height: 200}, 5)
  r1 = {x:0, y:0, width: 10, height: 10}
  o1 = {x:0, y:0, width: 10, height: 10, id:17}

  # tests
  it 'should be able to insert and retrieve an object', ()->
    qt.insert(o1)
    test = qt.retrieve(r1)[0]
    expect(test.id).to.equal(o1.id)

  it 'should be able to insert and retrieve a number of objects that is larger than maxobject', ()->
    testarr = []
    succeed = false
    for i in [1..20]
      x = parseInt(Math.random()*200)-100
      y = parseInt(Math.random()*200)-100
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

  it 'should be able to insert and remove an object', ()->
    r2 = {x:5, y:2, width: 10, height: 10}
    o2 = {x:5, y:2, width: 10, height: 10, id:4711}
    qt.insert(o2)
    qt.remove(r2)
    result = qt.retrieve(r2)
    expect(result.length).to.equal(0)

  it 'should be able to insert a large object in a split tree and verify it stays in the top node', ()->
    testarr = []
    succeed = false
    for i in [1..20]
      x = parseInt(Math.random()*100)
      y = parseInt(Math.random()*100)
      o = {x: x, y: y, width: 10, height: 10, id:i}
      r = {x: x, y: y, width: 10, height: 10}
      testarr.push {o: o, r: r}
      qt.insert(o)
    r3 = {x:-50, y:-50, width: 100, height: 100}
    o3 = {x:-50, y:-50, width: 100, height: 100, id:111}
    qt.insert(o3)
    #console.log '.....................................'
    #console.dir(qt.objects)
    exists = false
    qt.objects.forEach (oo)-> if oo.id == 111 then exists = true
    expect(exists).to.equal(true)

  it 'should be able to collide two overlapping rects', ()->
    o1 = {x:0, y:0, width: 10, height: 10, id:176}
    o2 = {x:-5, y:-5, width: 10, height: 10, id:4712}
    qt.insert(o1)
    qt.insert(o2)
    collissions = qt.getCollissionsFor(o1)
    #console.dir(collissions)
    exists = false
    collissions.forEach (oo)-> if oo.id == 4712 then exists = true
    expect(exists).to.equal(true)