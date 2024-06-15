extends Control

var check : AnimatedSprite2D
var title : RichTextLabel
var unachievedFrame: int = 0
var achievedFrame: int = 1
var heldAchievement: Achievement

# Called when the node enters the scene tree for the first time.
func _ready():
	check = $'Check'
	title = $'Title'
	check.frame = unachievedFrame


func achieved():
	check.frame = achievedFrame
	
func setAchivement(achievement: Achievement):
	heldAchievement = achievement
	title.text = achievement.displayName
