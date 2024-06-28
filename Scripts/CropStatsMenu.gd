extends Control

@export var statObject:PackedScene

var panelName = "cropStatsMenu"
var items = []
var statObjects = []

var rows:int = 3
var columns:int = 2
var rowStart:int = 5
var colStart:int = 5
var rowThickness:int = 22
var colThickness:int = 121
var curCol:int = 1
var curRow:int = 1

var nextUnlockXPos:int = 0
var nextUnlockYPos:int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	EventBus.connect('harvested', updateList)
	EventBus.connect('opened', processOpenPanel)
	EventBus.connect('gameLoaded', initiateList)
	resetPositions()
	
	
func _process(_delta):
	if(Input.is_action_just_pressed("ShowStats")):
		if(!visible):
			EventBus.emit_signal("opened", panelName)
		visible = !visible

func processOpenPanel(panelOpened):
	if(panelOpened != panelName):
		hide()
	else:
		visible = !visible
	
		
func initiateList():
	var cropList = FarmStatistics.cropsCollected
	for crop in cropList:
		if cropList[crop] > 0:
			updateListByString(crop)

func updateList(crop):
	updateListByString(crop.name)

func updateListByString(cropName):
	if(!items.any(func(x): return x == cropName)):
		print('adding crop')
		items.append(cropName)
		populateStat(cropName)
	var numCollected = FarmStatistics.getNumCollectedByString(cropName)
	var newText = '{cropName} collected: {numCollected}'.format({"cropName":cropName, "numCollected":numCollected})
	var index = items.find(cropName)
	statObjects[index].setName(newText)


func populateStat(cropName):
	var newStatScene = statObject.instantiate()
	add_child(newStatScene)
	statObjects.append(newStatScene)
	newStatScene.position.x = nextUnlockXPos
	newStatScene.position.y = nextUnlockYPos
	curCol += 1
	newStatScene.setSprite(null)
	newStatScene.setType('stat')
	newStatScene.setName(cropName)
	updateUnlockPosition()
	
func resetPositions():
	nextUnlockXPos = rowStart
	nextUnlockYPos = colStart
	
func updateUnlockPosition():
	if (curCol > columns):
		curCol = 1
		curRow += 1
		nextUnlockXPos = rowStart
		nextUnlockYPos += rowThickness
	else:
		nextUnlockXPos += colThickness
