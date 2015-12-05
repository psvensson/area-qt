class QuadTree

  #---------------------------------------------------------------------- External

  constructor: (@bounds, @maxObjectsPerLevel) ->
    @subTrees = []
    @objects  = []

  insert: (rect) =>
    # If we have subtrees
    if @subTrees.length > 0
      # does the rect fit fully into a subtree?
      index = @._getIndexFor(rect)
      if index > -1
        # then insert it into the subtree
        @subTrees[index].insert(rect)
      else
        @._doInsert(rect)
    else
      @._doInsert(rect)

  retrieve: (rect) =>
    rv = undefined
    # if we have subtrees
    index = @._getIndexFor(rect)
    if @subTrees.length > 0 and index > -1
      # if rect fits into a subtree, then call retrieve on that
      rv = @subTrees[index].retrieve(rect)
    else
      # otherwise see if we can find the rect within our own objects
      @objects.forEach (object) ->
        console.log '-- comparing '+rect+' and '+object
        if object.x == rect.x and object.y = rect.y and object.width == rect.width and object.height == rect.height then rv = object
    rv

  remove: (rect) =>


  getCollissionsFor: (rect) =>


  #---------------------------------------------------------------------- Internal

  _getIndexFor: (rect) =>
    index = -1
    [horizontalMidpoint, verticalMidpoint] = @._getMidPoints()
    topQuadrant = rect.y < horizontalMidpoint and rect.y + rect.height < horizontalMidpoint
    bottomQuadrant = rect.y > horizontalMidpoint
    #rect can completely fit within the left quadrants
    if rect.x < verticalMidpoint and rect.x + rect.width < verticalMidpoint
      if topQuadrant
        index = 1
      else if bottomQuadrant
        index = 2
    #rect can completely fit within the right quadrants
    else if rect.x > verticalMidpoint
      if topQuadrant
        index = 0
      else if bottomQuadrant
        index = 3
    index

  _getMidPoints: ()=>
    [@bounds.x + @bounds.width / 2, @bounds.y + @bounds.height / 2]

  _doInsert: (rect) =>
    # if we are at maximum object per level
    if @objects.length > @maxObjectsPerLevel
      # split into four new subtrees
      [horizontalMidpoint, verticalMidpoint] = @._getMidPoints()
      @subTrees.push(new QuadTree({x: @bounds.x + horizontalMidpoint, y: @bounds.y,                     width: @bounds.width/2, height: @bounds.height/2}))
      @subTrees.push(new QuadTree({x: @bounds.x, y: @bounds.y,                                          width: @bounds.width/2, height: @bounds.height/2}))
      @subTrees.push(new QuadTree({x: @bounds.x, y: @bounds.y + verticalMidpoint,                       width: @bounds.width/2, height: @bounds.height/2}))
      @subTrees.push(new QuadTree({x: @bounds.x + horizontalMidpoint, y: @bounds.y + verticalMidpoint,  width: @bounds.width/2, height: @bounds.height/2}))
      # and insert it into the correct new subtree
      @subTrees[@._getIndexFor(rect)].insert(rect)
    else
      # otherwise insert the rect here
      @objects.push(rect)

module.exports = QuadTree