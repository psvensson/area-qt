// Generated by CoffeeScript 1.9.3
(function() {
  var QuadTree, expect;

  expect = require('chai').expect;

  QuadTree = require('../lib/QuadTree');

  describe('QuadTree Tests', function() {
    var qt, r1;
    qt = new QuadTree({
      x: -100,
      y: -100,
      width: 200,
      height: 200
    }, 10);
    r1 = {
      x: -1,
      y: -1,
      width: 10,
      height: -10
    };
    return it('should be able to insert and retrieve a rect', function(done) {
      var test;
      qt.insert(r1);
      test = qt.retrieve(r1);
      expect(test).to.equal(r1);
      return done();
    });
  });

}).call(this);

//# sourceMappingURL=qt-spec.js.map
