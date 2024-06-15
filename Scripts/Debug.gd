extends Control

@export var bounceScene: PackedScene

var debugModeOn = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("debug")):
		debugModeOn = !debugModeOn
		hide()
		if(debugModeOn):
			show()
	if(Input.is_action_just_pressed("skipTime")):
		_on_ticks_pressed()
		
func spawnBounce():
	var bouncyThing = bounceScene.instantiate()
	add_child(bouncyThing)
	bouncyThing.position.x = 100
	bouncyThing.position.y = 100
	
	


func _on_gold_up_pressed():
	PlayerContext.gain_gold(1000)


func _on_xp_up_pressed():
	PlayerContext.gain_exp(1000)


func _on_gold_down_pressed():
	var currentGold = PlayerContext.currentGold
	var goldToLose = min(currentGold, 1000)
	PlayerContext.gain_gold(-goldToLose)


func _on_ticks_pressed():
	for n in 1000:
		EventBus.emit_signal("ticked")
