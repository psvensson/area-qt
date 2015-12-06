class QuadTree

  #---------------------------------------------------------------------- External

  constructor: (@bounds, @maxObjectsPerLevel) ->
    @subTrees = []
    @objects  = []

  insert: (rect) =>
    #console.log '_doInsert called for '+rect.x+','+rect.y+' tree '+@bounds.x+','+@bounds.y+' - '+@bounds.width+','+@bounds.height+' objects.length is '+@objects.length+' maxobjects are '+@maxObjectsPerLevel
    if rect.x < @bounds.x or rect.x > @bounds.x + @bounds.width or rect.y < @bounds.y or rect.y > @bounds.y + @bounds.height
      xyzzy()
    # if we are at maximum object per level
    #console.log 'inserting object '+rect.x+','+rect.y
    ind = @._getIndexFor(rect)
    if @subTrees.length > 0 and ind > -1 then @subTrees[ind].insert(rect) else @objects.push(rect)
    if @objects.length > @maxObjectsPerLevel
      #console.log 'splitting......................................................................'
      # split into four new subtrees
      @subTrees.push(new QuadTree({x: @bounds.x + @bounds.width/2, y: @bounds.y,                     width: @bounds.width/2, height: @bounds.height/2}, @maxObjectsPerLevel))
      @subTrees.push(new QuadTree({x: @bounds.x, y: @bounds.y,                                       width: @bounds.width/2, height: @bounds.height/2}, @maxObjectsPerLevel))
      @subTrees.push(new QuadTree({x: @bounds.x, y: @bounds.y + @bounds.height/2,                    width: @bounds.width/2, height: @bounds.height/2}, @maxObjectsPerLevel))
      @subTrees.push(new QuadTree({x: @bounds.x + @bounds.width/2, y: @bounds.y + @bounds.height/2,  width: @bounds.width/2, height: @bounds.height/2}, @maxObjectsPerLevel))
      # move all existing rects on our tree that fits into the new subtrees
      newObjects = []
      for o,i in @objects
        index = @._getIndexFor(o)
        #console.log 'subtree index for object '+o.x+','+o.y+' is '+index
        if index > -1
          subtree = @subTrees[index]
          #console.log 'post-split inserting object '+o.x+','+o.y+' into subtree with index '+index+' -> '+subtree
          subtree.insert(o)
        else
          #console.log 'post-split leaving object '+o.x+','+o.y+' in this tree '
          newObjects.push o
      @objects = newObjects

  retrieve: (rect) =>
    #console.log 'retrieve at tree '+@bounds.x+','+@bounds.y+' - '+@bounds.width+','+@bounds.height+' called for '+rect.x+','+rect.y
    rv = []
    # if we have subtrees
    index = @._getIndexFor(rect)
    if @subTrees.length > 0 and index > -1
      # if rect fits into a subtree, then call retrieve on that
      rv = @subTrees[index].retrieve(rect)
    else
      # otherwise see if we can find the rect within our own objects
      @objects.forEach (object) ->
        #console.log '-- comparing '+rect.x+','+rect.y+' and '+object.x+','+object.y
        if object.x == rect.x and object.y == rect.y and object.width == rect.width and object.height == rect.height
          #console.log '*match*'
          rv.push object
    rv

  remove: (rect) =>
    # find subtree that contains the rect

    # remove object from subtree

    # does all objects in me and my siblings subtrees equal to less than maxObjects?

    # then move our objects up into the parent subtree

    # and delete us

    # return object that was removed


  getCollissionsFor: (rect) =>


  #---------------------------------------------------------------------- Internal

  _getIndexFor: (rect) =>
    index = -1
    [midx,midy] = @._getMidPoints()

    top     = rect.y < midy and (rect.y + rect.height) < midy
    bottom  = rect.y >= midy and (rect.y + rect.height) < @bounds.y + midy
    left    = rect.x < midx and (rect.x + rect.width) < midx
    right   = rect.x >= midx and (rect.x + rect.width) < @bounds.x + midx

    if top and right then index = 0
    if top and left then index = 1
    if bottom and left then index = 2
    if bottom and right then index = 3

    #console.log '_getIndexFor for '+rect.x+','+rect.y+' - '+rect.width+','+rect.height+' returns '+index+' horizontal midpoint = '+midy+', vertical midpoint = '+midx+', bounds = '+@bounds.x+','+@bounds.y+' - '+@bounds.width+','+@bounds.height
    index

  _getMidPoints: ()=> [@bounds.x + @bounds.width / 2, @bounds.y + @bounds.height / 2]


module.exports = QuadTree