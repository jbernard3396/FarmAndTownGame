extends ItemList

var panelName = "achievementStatsMenu"
var items = []


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	EventBus.connect('loaded', updateExisting)
	EventBus.connect('achieved', updateAchieved)
	EventBus.connect('opened', closePanel)
	
func _process(_delta):
	if(Input.is_action_just_pressed("ShowAchievements")):
		if(!visible):
			EventBus.emit_signal("opened", panelName)
		visible = !visible

func closePanel(panelOpened):
	if(panelOpened != panelName):
		hide()

func updateExisting(achievement):
	if(!(achievement is Achievement)):
		return
	print('setting icon')
	set_item_icon(items.size(), achievement.sprite)
	
func updateAchieved(achievement):
	print('update acchievement')

		

