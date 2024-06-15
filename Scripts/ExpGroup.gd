extends Control

var expBarGUI
var expAmountGUI
var levelGUI

func _ready():
	EventBus.connect("expChanged", update_exp)
	expBarGUI = $'ExpBar'
	expAmountGUI = $'ExpAmount'
	levelGUI = $'Level'
	update_exp()

func update_exp():
	update_exp_bar()
	update_exp_amount()
	update_level()

func update_exp_bar():
	expBarGUI.value = PlayerContext.currentExp
	expBarGUI.max_value = PlayerContext.expToNextLevel

func update_exp_amount():
	expAmountGUI.text = '{currentExp}/{expToNextLevel}'.format({'currentExp':PlayerContext.currentExp, 'expToNextLevel':PlayerContext.expToNextLevel})
	
func update_level():
	levelGUI.text = 'Level: {level}'.format({'level':PlayerContext.currentLevel})
