extends AnimatedSprite2D

@export var crop_sprites : SpriteFrames

var lockedRect
var selectedRect
var crop : Crop

var affordable = false
var unlocked = false

func _ready():
	EventBus.connect('gameLoaded', processGameLoaded)

func instantiate():
	lockedRect = $'LockedIcon'
	selectedRect = $'SelectedIcon'
	update_purchaseable()
	EventBus.connect("goldChanged", update_purchaseable)
	EventBus.connect("cropChanged", update_selected)
	EventBus.connect("itemSelected", processItemSelected)
	EventBus.connect("nothingSelected", processNothingSelected)
	
func processGameLoaded():
	update_purchaseable()
	

func _on_button_pressed():
	EventBus.emit_signal("itemSelected", crop)
	EventBus.emit_signal("cropChanged", crop)

func update_purchaseable():
	affordable = (PlayerContext.currentGold >= crop.cost)
	unlocked = (PlayerContext.currentLevel >= crop.requiredLevel)
	show()
	lockedRect.hide()
	if(!unlocked):
		hide()
	if(!affordable):
		lockedRect.show()
		
func update_selected(selectedCrop):
	selectedRect.hide()
	if(selectedCrop.id == crop.id):
		selectedRect.show()
		
func processNothingSelected():
	clear_selected()
	
func processItemSelected(_x):
	clear_selected()
		
func clear_selected():
	selectedRect.hide()
