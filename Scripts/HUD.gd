extends CanvasLayer

var panelsToHideFrom:Array = ['AchievementPanel', 'LevelUpNotification']

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect('opened', processOpen)


func processOpen(panelName):
	print(panelName)
	if (panelsToHideFrom.find(panelName) >=0):
		hide()
	else:
		show()
	
