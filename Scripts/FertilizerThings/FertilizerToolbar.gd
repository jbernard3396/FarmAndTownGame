extends Panel

var fetilizerData = {}
var fertilizerDataPath = 'res://Assets/Data/FertilizerData.json'
var growingFertilizerSpritePath = 'res://Assets/animations/Growing/Fertilizer/'
var menuFertilizerSpritePath = 'res://Assets/animations/Menu/Fertilizer/'

@export var MenuFertilizerScene : PackedScene

var currentX = 9
var currentY = 26



func _ready():
	fetilizerData = JsonUtils.loadJsonFile(fertilizerDataPath)
	loadFertilizers()
	EventBus.connect('toolbarOpened', processToolbarOpened)

func processToolbarOpened(toolbarOpenedName):
	show()
	if toolbarOpenedName != name:
		hide()
	

func loadFertilizers():
	for fertilizer in fetilizerData:
		loadFertilizer(fetilizerData[fertilizer])
		
func loadFertilizer(fertilizer):
	var newFertilizerObject = MenuFertilizerScene.instantiate()
	add_child(newFertilizerObject)
	newFertilizerObject.position.x = currentX
	newFertilizerObject.position.y = currentY
	updateCurrentPos()
	var newFertilizer = Fertilizer.new()
	for key in fertilizer:
		newFertilizer[key] = fertilizer[key]
	newFertilizer.function = Callable(self, newFertilizer.function)
	newFertilizer.sprite = getGrowingSprites(fertilizer["name"])
	newFertilizerObject.fertilizer = newFertilizer
	newFertilizerObject.sprite_frames = getMenuSprites(fertilizer["name"])
	newFertilizerObject.instantiate()
	EventBus.emit_signal("loaded", newFertilizer)

func getGrowingSprites(fertilizerName):
	var path = growingFertilizerSpritePath + fertilizerName + '_growing.tres'
	return getResources(path)
	
func getMenuSprites(fertilizerName):
	var path = menuFertilizerSpritePath + fertilizerName + '_menu.tres'
	return getResources(path)

func getResources(path):
	if !ResourceLoader.exists(path):
		print("error finding resource: " + path )
		return
	return ResourceLoader.load(path)

func updateCurrentPos():
	currentX += 18
	
func topazFertilizer(crop):
	Functions.multiplyGrowTime(crop, .5)
	Functions.multiplyGold(crop, .25)
	
func emeraldFertilizer(crop):
	Functions.multiplyGrowTime(crop, .5)
	Functions.multiplyExp(crop, .25)
	
func rubyFertilizer(crop):
	Functions.multiplyGrowTime(crop, 2)
	Functions.multiplyGold(crop, 3)
	Functions.multiplyExp(crop, 3)

