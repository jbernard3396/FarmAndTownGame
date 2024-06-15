extends Control
@export var tiles : SpriteFrames
@export var water : PackedScene
var offsetX = -2
var offsetY = -2

# Called when the node enters the scene tree for the first time.
func _ready():
	createBackground()
	

func createBackground():
	createWater()
	createGrass()

func createWater():
	var numTilesHorizontal = Utils.intDiv(320,16)+1
	var numTilesVertical = Utils.intDiv(130,16)+1
	for x in range(numTilesHorizontal):
		for y in range(numTilesVertical):
			var x_pos = x *16 + offsetX
			var y_pos = y *16 + offsetY
			var newWater = water.instantiate()
			newWater.position = Vector2(x_pos,y_pos)
			add_child(newWater)
	
	
func createGrass():
	var numTilesHorizontal = Utils.intDiv(320,16)
	var numTilesVertical = Utils.intDiv(130,16)
	for x in range(1, numTilesHorizontal):
		for y in range(1, numTilesVertical):
			var x_pos = x *16 + offsetX-8
			var y_pos = y *16 + offsetY-8
			var newTileFrame = getGrassAnimationAndFrame(x, y, numTilesHorizontal, numTilesVertical)
			var newSprite = AnimatedSprite2D.new()
			newSprite.position = Vector2(x_pos,y_pos)
			newSprite.sprite_frames = tiles
			newSprite.animation = newTileFrame.animation
			newSprite.frame = newTileFrame.frame

			newSprite.centered = false
			add_child(newSprite)
			

func getGrassAnimationAndFrame(x, y, numTilesHorizontal, numTilesVertical):
	var maxX = numTilesHorizontal - 1
	var maxY = numTilesVertical - 1
	var minX = 1
	var minY = 1
	
	if (x == minX):
		if (y == minY):
			return createAnimationAndFrameObject('edge', 0)
		if(y == maxY):
			return createAnimationAndFrameObject('edge', 6)
		return createAnimationAndFrameObject('edge', 7)
	if (x == maxX):
		if (y == minY):
			return createAnimationAndFrameObject('edge', 2)
		if(y == maxY):
			return createAnimationAndFrameObject('edge', 4)
		return createAnimationAndFrameObject('edge', 3)
	if(y == minY):
		return createAnimationAndFrameObject('edge', 1)
	if(y == maxY):
		return createAnimationAndFrameObject('edge', 5)
	var randomFrame = getRandomFrame(tiles)
	return createAnimationAndFrameObject('center', randomFrame)

func getRandomFrame(AS2d : SpriteFrames):
	if(randf() < .7):
		return 0
	return randi_range(0, AS2d.get_frame_count('center'))
	
func createAnimationAndFrameObject(animationName, frameNumber):
	return {'animation':animationName, 'frame':frameNumber}
