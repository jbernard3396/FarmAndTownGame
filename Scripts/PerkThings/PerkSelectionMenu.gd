extends Control

@export var perkObject:PackedScene

var panelName = "perksSelectionMenu"
var items = []
var perkObjects = []
var numPerksToPopulate = 2
var selectedPerkIndex: int = -1
var type:String = 'perk'

var rows:int = 3
var columns:int = 2
var rowStart:int = 5
#todo: this should be 5, but that causes an odd visual bug
var colStart:int = 6
var rowThickness:int = 22
var colThickness:int = 121
var curCol:int = 1
var curRow:int = 1

var nextUnlockXPos:int = 0
var nextUnlockYPos:int = 0


func _ready():
	hidePanel()
	populatePerks()
	EventBus.connect('opened', processOpenPanel)
	EventBus.connect('nothingSelected', processNothingSelected)



func _process(_delta):
	#todo: this doesn't appear to work
	if(Input.is_action_just_pressed("ShowPerks")):
		if(!visible):
			EventBus.emit_signal("opened", panelName)
		visible = !visible
		
	
func showPerkMenu():
	visible = true;
	EventBus.emit_signal("opened", panelName)

func processOpenPanel(panelOpened):
	if(panelOpened != panelName):
		hidePanel()
	else:
		show()

func populatePerks():
	clearPerks()
	var validPerks = getValidPerks()
	var perkIndexes = []
	var numPerks = validPerks.size()
	perkIndexes = Utils.selectFromList(numPerksToPopulate, numPerks)
	for perkIndex in perkIndexes:
		var currentPerk = validPerks[perkIndex]
		var currentPerkObject = createPerkObject(currentPerk, items.size())
		items.append(currentPerk)
		perkObjects.append(currentPerkObject)
		
func createPerkObject(currentPerk, perkIndex):
	var newPerk = perkObject.instantiate()
	add_child(newPerk)
#	unlockChildren.append(newPerk)
	newPerk.position.x = nextUnlockXPos
	newPerk.position.y = nextUnlockYPos
	curCol += 1
	newPerk.setSprite(currentPerk.unlockSprites)
	newPerk.setType(type)
	newPerk.setName(currentPerk.displayName)
	newPerk.setGroupName(panelName)
	newPerk.setIndex(perkIndex)
	newPerk.isSelectable = true
	newPerk.connect("DisplaySelected", processSelected)
	updateUnlockPosition()
	return newPerk

func updateUnlockPosition():
	if (curCol > columns):
		curCol = 1
		curRow += 1
		nextUnlockXPos = rowStart
		nextUnlockYPos += rowThickness
	else:
		nextUnlockXPos += colThickness
		
func resetPositions():
	nextUnlockXPos = rowStart
	nextUnlockYPos = colStart

func getValidPerks():
	var validPerks = []
	for perkKey in FarmPerks.perks:
		var allTrue = true
		var currentPerk = FarmPerks.perks[perkKey]
		for requirement in currentPerk.requirements:
			if requirement.req.call(requirement.arguments) == false:
				allTrue = false
		if allTrue == true:
			validPerks.append(FarmPerks.perks[perkKey])
	return validPerks
			

func clearPerks():
	resetPositions()
	selectedPerkIndex = -1
	items.clear()
	perkObjects.clear()
	
func hidePanel():
	hide()
	

func processNothingSelected():
	clear_selection()

func clear_selection():
	selectedPerkIndex = -1
	
func processSelected(_group, index):
	deselectPerk()
	EventBus.emit_signal('itemSelected', items[index])
	selectedPerkIndex = index
	setSelectedPerk()
	
func deselectPerk():
	if(selectedPerkIndex == null or selectedPerkIndex == -1):
		return
	var perkToDeselect = perkObjects[selectedPerkIndex]
	print(perkToDeselect)
	perkToDeselect.setUnselected()
	
func setSelectedPerk():
	var perkToSelect = perkObjects[selectedPerkIndex]
	print(perkToSelect)
	perkToSelect.setSelected()

func _on_confirmation_button_pressed():
	if(PlayerContext.currentPerkPoints <= 0 or selectedPerkIndex == -1):
		return
	FarmPerks.claim(items[selectedPerkIndex].displayName)
	populatePerks()
	EventBus.emit_signal('nothingSelected')
	if(PlayerContext.currentPerkPoints<= 0):
		EventBus.emit_signal("opened", "")
