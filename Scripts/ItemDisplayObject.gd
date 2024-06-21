extends Control

var isSelectable:bool = false : set = setSelectable
var groupName:String

var index: int
var spriteChild:AnimatedSprite2D
var panel:AnimatedSprite2D
var panelToUse:AnimatedSprite2D
var selectablePanel:AnimatedSprite2D
var descriptionChild
var descriptionText = 'test': get=getDescriptionText
var textPositionNoSprite = 5
var textPositionWithSprite = 23

signal DisplaySelected(groupName, index)

func getDescriptionText():
	if (descriptionType == 'perk' or descriptionType == 'stat'):
		return '{descriptionName}'.format({'descriptionName':descriptionName})
	return 'New {descriptionType}: {descriptionName}'.format({'descriptionType':descriptionType, 'descriptionName':descriptionName})

var descriptionType
var descriptionName

func _ready():
	spriteChild = $'Sprite'
	selectablePanel=$'SelectablePanel'
	panel = $'Panel'
	showCorrectPanel()
	descriptionChild = $'Description'
	descriptionType = 'testType'
	descriptionName = 'testName'

func setSprite(spriteFrames):
	spriteChild.sprite_frames = spriteFrames

func setType(type):
	descriptionType = type
	updateDescriptionText()

func setName(descName):
	descriptionName = descName
	updateDescriptionText()

func setGroupName(group:String):
	groupName = group

func setIndex(idx:int):
	index = idx

func setSelectable(selectable):
	isSelectable = selectable
	showCorrectPanel()
	
func showCorrectPanel():
	if(isSelectable):
		panelToUse = selectablePanel
		panel.hide()
		selectablePanel.show()
	else:
		panelToUse = panel
		panel.show()
		selectablePanel.hide()

func setSelected():
	panelToUse.frame = 1
	descriptionChild.position.y += 2

func setUnselected():
	panelToUse.frame = 0
	descriptionChild.position.y -= 2

func updateDescriptionText():
	descriptionChild.text = descriptionText
	if(!spriteChild.sprite_frames):
		descriptionChild.position.x = textPositionNoSprite
	else:
		descriptionChild.position.x = textPositionWithSprite

func _on_temp_button_button_down():
	print('temp utton down')
	emit_signal("DisplaySelected", groupName, index)
