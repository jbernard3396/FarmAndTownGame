extends Node

var tickLength = 1
var timeSinceLastTick = 0

func _process(delta):
	passTime(delta)
	
	
func passTime(delta):
	timeSinceLastTick += delta
	while(timeSinceLastTick > tickLength):
		print('ticking');
		timeSinceLastTick -= tickLength
		EventBus.emit_signal("ticked")

