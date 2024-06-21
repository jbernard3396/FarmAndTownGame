extends AnimatedSprite2D

var fertilizer_sprite : SpriteFrames

var lockedRect
var selectedRect
var fertilizer : Fertilizer

var affordable = false
var unlocked = false

func instantiate():
	lockedRect = $'LockedIcon'
	selectedRect = $'SelectedIcon'
	update_purchaseable()
	EventBus.connect("goldChanged", update_purchaseable)
	EventBus.connect("fertilizerChanged", update_selected)
	EventBus.connect("itemSelected", processItemSelected)
	EventBus.connect("nothingSelected", processNothingSelected)
	EventBus.connect('gameLoaded', processGameLoaded)

func processGameLoaded():
	update_purchaseable()
	
	

func _on_button_pressed():
	EventBus.emit_signal("itemSelected", fertilizer)
	EventBus.emit_signal("fertilizerChanged", fertilizer)

func update_purchaseable():
	affordable = (PlayerContext.currentGold >= fertilizer.cost)
	unlocked = (PlayerContext.currentLevel >= fertilizer.requiredLevel)
	show()
	lockedRect.hide()
	if(!unlocked):
		hide()
	if(!affordable):
		lockedRect.show()
		
func update_selected(selectedFertilizer):
	selectedRect.hide()
	if(selectedFertilizer.id == fertilizer.id):
		selectedRect.show()
		
func processNothingSelected():
	clear_selected()
	
func processItemSelected(_x):
	clear_selected()

func clear_selected():
	selectedRect.hide()
