extends Control

@export var buttonAction : Script
@export var buttonSprites : SpriteFrames
@export var toolbarName : String
var menuButtonTab : AnimatedSprite2D
var menuButtonIcon : AnimatedSprite2D
var menuButtonButton
var menuButtonOffPosition : Vector2

func _ready():
	menuButtonIcon = $'MenuButtonIcon'
	menuButtonButton = $'MenuButtonButton'
	menuButtonTab = $'MenuButtonTab'
	menuButtonIcon.sprite_frames = buttonSprites
	menuButtonOffPosition = menuButtonIcon.position
	EventBus.connect('toolbarOpened', processToolBarOpened)
	

func processToolBarOpened(openedToolbarName):
	if (openedToolbarName == toolbarName):
		menuButtonTab.frame = 1
		menuButtonIcon.position.y = menuButtonOffPosition.y - 1
	elif(menuButtonTab.frame == 1):
		menuButtonTab.frame = 0
		menuButtonIcon.position.y = menuButtonOffPosition.y
		

func _on_menu_button_button_pressed():
	buttonAction.call('_on_pressed')
	menuButtonTab.frame = 1
	
