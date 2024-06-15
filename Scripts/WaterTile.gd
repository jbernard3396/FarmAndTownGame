extends Control

var waterSprite: AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	waterSprite = $'sprite'
	waterSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
