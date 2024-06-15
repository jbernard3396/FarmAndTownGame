extends Control

@export var achievementScene:PackedScene
var congratulationsChild
var panelName = 'AchievementNotification'
var currentAchievement: Achievement
var achievementSprite: AnimatedSprite2D
var achievementPos: Vector2
var newAchievmentObject:Node


# Called when the node enters the scene tree for the first time.
func _ready():
	congratulationsChild = $'Congratulations'
	achievementSprite = $'Achievement'
	achievementPos = achievementSprite.position
	newAchievmentObject = achievementScene.instantiate()
	add_child(newAchievmentObject)
	hidePanel()
	EventBus.connect('opened', closePanel)
	EventBus.connect('achieved', processAchievement)
	
func processAchievement(achievement):
	currentAchievement = achievement
	updateCongratulationsText()
	instantiateObject()
	openPanel()

func updateCongratulationsText():
	congratulationsChild.text = "Congratulations! You achieved {achievementDisplayName}".format({'achievementDisplayName':currentAchievement.displayName})
	
func instantiateObject():
	newAchievmentObject.setAchivement(currentAchievement)
	newAchievmentObject.achieved()
	newAchievmentObject.scale.x = 4
	newAchievmentObject.scale.y = 4
	newAchievmentObject.position = achievementPos
	
	newAchievmentObject.show()
		

func hidePanel():
	hide()
	
func openPanel():
	
	show()
	
	
func closePanel(panelOpened):
	if(panelOpened != panelName):
		hidePanel()

func _on_close_button_pressed():
	hidePanel()
