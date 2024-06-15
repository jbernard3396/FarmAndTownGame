extends Control
@export var unlockScene: PackedScene
@export var cornSprite: SpriteFrames

var congratulationsChild
var unlockChildren = []

var panelName = 'LevelUpNotification'
var perkMenuName = 'perksSelectionMenu'

var rows:int = 3
var columns:int = 2
var rowStart:int = 5
var colStart:int = 18
var rowThickness:int = 22
var colThickness:int = 121
var curCol:int = 1
var curRow:int = 1

var nextUnlockXPos:int = 0
var nextUnlockYPos:int = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	congratulationsChild = $'Congratulations'
	hidePanel()
	EventBus.connect('opened', closePanel)
	EventBus.connect('leveledUp', processLevel)
	resetPositions()


func updateCongratulationsText():
	congratulationsChild.text = 'Congratulations! you\'ve reached level {level}'.format({'level':PlayerContext.currentLevel})

func populateUnlocks():
	populateUnlockedCrops()
	populateUnlockedFertilizers()
	populateUnlockedPerks()
	
func populateUnlockedCrops():
	var unlockedCrops = CropDataService.freshlyUnlockedCrops()
	if unlockedCrops == null:
		return
	for unlockedCrop in unlockedCrops:
		populateUnlock(unlockedCrop, 'Crop')
		
func populateUnlockedFertilizers():
	var unlockedFertilizers = FertilizerDataService.freshlyUnlockedFertilizers()
	if unlockedFertilizers == null:
		return
	for unlockedFertilizer in unlockedFertilizers:
		populateUnlock(unlockedFertilizer, 'Fertilizer')
		
func populateUnlockedPerks():
	var unlockedPerks = PerkDataService.freshlyUnlockedPerks()
	if unlockedPerks == null:
		return
	for unlockedPerk in unlockedPerks:
		populateUnlock(unlockedPerk, 'Perk')
		
func populateUnlock(unlock, type):
	var newUnlockScene = unlockScene.instantiate()
	add_child(newUnlockScene)
	unlockChildren.append(newUnlockScene)
	newUnlockScene.position.x = nextUnlockXPos
	newUnlockScene.position.y = nextUnlockYPos
	curCol += 1
	newUnlockScene.setSprite(unlock.unlockSprites)
	newUnlockScene.setType(type)
	newUnlockScene.setName(unlock.displayName)
	updateUnlockPosition()
	

func updateUnlockPosition():
	if (curCol > columns):
		curCol = 1
		curRow += 1
		nextUnlockXPos = rowStart
		nextUnlockYPos += rowThickness
	else:
		nextUnlockXPos += colThickness
	

func hidePanel():
	hide()
	
func openPanel():
	EventBus.emit_signal("opened", panelName)
	show()
	
func closePanel(panelOpened):
	if(panelOpened != panelName):
		hidePanel()
		
func processLevel():
	openPanel()
	populateUnlocks()
	updateCongratulationsText()

func clear():
	hidePanel()
	resetPositions()
	for unlockChild in unlockChildren:
		unlockChild.queue_free()
	unlockChildren = []
	
func resetPositions():
	nextUnlockXPos = rowStart
	nextUnlockYPos = colStart

func _on_button_pressed():
	EventBus.emit_signal('opened', perkMenuName)
	clear()
