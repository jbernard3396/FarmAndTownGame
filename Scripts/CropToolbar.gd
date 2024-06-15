extends Panel

var cropData = {}
var cropDataPath = 'res://Assets/Data/CropData.json'
var growingCropSpritePath = 'res://Assets/animations/Growing/Crops/'
var menuCropSpritePath = 'res://Assets/animations/Menu/Crops/'
var collectableCropSpritePath = 'res://Assets/animations/Growing/Collectable/'


@export var CropScene : PackedScene

var currentX = 9
var currentY = 26


func _ready():
	cropData = JsonUtils.loadJsonFile(cropDataPath)
	loadCrops()
	EventBus.connect('toolbarOpened', processToolbarOpened)

func processToolbarOpened(toolbarOpenedName):
	show()
	if toolbarOpenedName != name:
		hide()
	

func loadCrops():
	for crop in cropData:
		loadCrop(cropData[crop])
		
func loadCrop(crop):
	var newCropObject = CropScene.instantiate()
	add_child(newCropObject)
	newCropObject.position.x = currentX
	newCropObject.position.y = currentY
	updateCurrentPos()
	var newCrop = Crop.new()
	for key in crop:
		newCrop[key] = crop[key]
	newCrop.sprites = getGrowingSprites(crop["name"])
	newCrop.menuSprites = getMenuSprites((crop["name"]))
	newCrop.collectableSprites = getCollectableSprites(crop["name"])
	if(!newCrop.sprites == null):
		newCrop.numFrames = newCrop.sprites.get_frame_count("default") 
	newCropObject.crop = newCrop
	newCropObject.sprite_frames = getMenuSprites(crop["name"])
	newCropObject.instantiate()
	EventBus.emit_signal("loaded", newCrop)
	

func getGrowingSprites(cropName):
	var path = growingCropSpritePath + cropName + '_growing.tres'
	return getResources(path)
	
func getMenuSprites(cropName):
	var path = menuCropSpritePath + cropName + '_menu.tres'
	return getResources(path)
	
func getCollectableSprites(cropName):
	var path = collectableCropSpritePath + cropName + '_collectable.tres'
	return getResources(path)

func getResources(path):
	if !ResourceLoader.exists(path):
		print("error finding resource: " + path )
		return
	return ResourceLoader.load(path)

func updateCurrentPos():
	currentX += 18
	

