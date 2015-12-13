asciitree = require('ascii-tree')

class QuadTree

  #---------------------------------------------------------------------- External

  constructor: (@bounds, @maxObjectsPerLevel, @parent, @idProperty = 'id') ->
    @subTrees = []
    @objects  = []
    #console.log 'new tree '+@bounds.x+','+@bounds.y+' - '+@bounds.width+','+@bounds.height

  insert: (rect) =>
    #console.log 'insert called for '+rect.x+','+rect.y+' tree '+@bounds.x+','+@bounds.y+' - '+@bounds.width+','+@bounds.height+' objects.length is '+@objects.length+' maxobjects are '+@maxObjectsPerLevel
    if rect.x < @bounds.x or rect.x > @bounds.x + @bounds.width or rect.y < @bounds.y or rect.y > @bounds.y + @bounds.height
      xyzzy()
    # if we are at maximum object per level
    #console.log 'inserting object '+rect.x+','+rect.y
    if @objects.length > @maxObjectsPerLevel
      #console.log 'splitting......................................................................'
      # split into four new subtrees
      @subTrees.push(new QuadTree({x: @bounds.x + @bounds.width/2, y: @bounds.y,                     width: @bounds.width/2, height: @bounds.height/2}, @maxObjectsPerLevel, @))
      @subTrees.push(new QuadTree({x: @bounds.x, y: @bounds.y,                                       width: @bounds.width/2, height: @bounds.height/2}, @maxObjectsPerLevel, @))
      @subTrees.push(new QuadTree({x: @bounds.x, y: @bounds.y + @bounds.height/2,                    width: @bounds.width/2, height: @bounds.height/2}, @maxObjectsPerLevel, @))
      @subTrees.push(new QuadTree({x: @bounds.x + @bounds.width/2, y: @bounds.y + @bounds.height/2,  width: @bounds.width/2, height: @bounds.height/2}, @maxObjectsPerLevel, @))
      # move all existing rects on our tree that fits into the new subtrees
      newObjects = []
      for o,i in @objects
        index = @._getIndexFor(o)
        #console.log 'subtree index for object '+o.x+','+o.y+' is '+index
        if index > -1
          subtree = @subTrees[index]
          #console.log 'post-split inserting object '+o.x+','+o.y+' into subtree with index '+index+' -> '+subtree.bounds.x+','+subtree.bounds.y+' - '+subtree.bounds.width+','+subtree.bounds.height
          subtree.insert(o)
        else
          #console.log 'post-split leaving object '+o.x+','+o.y+' in this tree because it could not fit into any subtree of '+@bounds.x+','+@bounds.y+' - '+@bounds.width+','+@bounds.height
          newObjects.push o
      @objects = newObjects
    ind = @._getIndexFor(rect)
    if @subTrees.length > 0 and ind > -1
      tree = @subTrees[ind]
      #console.log '--> inserting into subtree '+tree.bounds.x+','+tree.bounds.y
      tree.insert(rect)
    else
      @objects.push(rect)

  retrieve: (rect) =>
    #console.log 'retrieve at tree '+@bounds.x+','+@bounds.y+' - '+@bounds.width+','+@bounds.height+' called for '+rect.x+','+rect.y
    rv = []
    # if we have subtrees
    index = @._getIndexFor(rect)
    if @subTrees.length > 0 and index > -1
      # if rect fits into a subtree, then call retrieve on that
      @subTrees[index].retrieve(rect)
    else
      # otherwise see if we can find the rect within our own objects
      @objects.forEach (object) ->
        #console.log '-- comparing '+rect.x+','+rect.y+' and '+object.x+','+object.y
        if object.x == rect.x and object.y == rect.y and object.width == rect.width and object.height == rect.height
          #console.log '*match*'
          rv.push object
    rv

  remove: (rect, id) =>
    # find subtree that contains the rect
    index = @._getIndexFor(rect)
    if @subTrees.length > 0 and index > -1
      @subTrees[index].remove(rect)
    else
      # remove object from subtree
      newObjects = []
      @objects.forEach (o) ->
        if id
          if o[@idProperty] == id then newObjects.push o
        else
          if o.x != rect.x or o.y != rect.y or o.width != rect.width or o.height != rect.height then newObjects.push o
      @objects = newObjects
    # does all objects in me and my siblings subtrees equal to less than maxObjects?
    if @objects.length < @maxObjectsPerLevel and @parent
      # then move our objects up into the parent subtree
      @parent.subTrees.forEach (st) => st.objects.forEach (o) => @parent.objects.push o
      # and delete us
      @parent.subTrees = []

  getCollissionsFor: (rect, rv) =>
    rv = rv or []
    @objects.forEach (o) =>
      if (@._isWithin(rect, o) or @._isWithin(o, rect)) then rv.push(o)
    index = @._getIndexFor(rect)
    if(index > -1)
      @subTrees[index].getCollissionsFor(rect, rv)
    else
      rv

  #---------------------------------------------------------------------- Internal

  _isWithin: (r1, r2) =>
    r1.x <= r2.x+r2.width and r1.x >= r2.x and r1.y <= r2.y+r2.height and r1.y >= r2.y

  _getIndexFor: (rect) =>
    index = -1
    [midx,midy] = @._getMidPoints()

    top     = rect.y < midy and (rect.y + rect.height) < midy
    bottom  = rect.y > midy and (rect.y + rect.height) < @bounds.y + @bounds.height
    left    = rect.x < midx and (rect.x + rect.width) < midx
    right   = rect.x > midx and (rect.x + rect.width) < @bounds.x + @bounds.width

    if top and right then index = 0
    if top and left then index = 1
    if bottom and left then index = 2
    if bottom and right then index = 3

    #console.log 'top = '+top+', bottom = '+bottom+', left = '+left+', right = '+right
    #console.log '_getIndexFor for '+rect.x+','+rect.y+' - '+rect.width+','+rect.height+' returns '+index+' horizontal midpoint = '+midy+', vertical midpoint = '+midx+', bounds = '+@bounds.x+','+@bounds.y+' - '+@bounds.width+','+@bounds.height
    index

  _getMidPoints: ()=> [@bounds.x + @bounds.width / 2, @bounds.y + @bounds.height / 2]

  _dumpTree: (level) =>
    # input = '#root node\r\n##node1\r\n###\r\nnode1\r\n##node2';
    # tree = asciitree.generate(str);


module.exports = QuadTree