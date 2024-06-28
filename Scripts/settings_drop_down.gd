extends Control

var dropDownBlock: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	dropDownBlock = $'DropDownBlock'
	dropDownBlock.hide()
	EventBus.connect('opened', processOpened)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_open_close_button_pressed():
	dropDownBlock.visible = !dropDownBlock.visible
	
func processOpened(_pageName):
	dropDownBlock.hide()


func _on_achievements_pressed():
	EventBus.emit_signal('opened', 'AchievementPanel')

func _on_stats_pressed():
	EventBus.emit_signal('opened', 'cropStatsMenu')

func _on_quit_pressed():
	EventBus.emit_signal('saveAndQuit')
