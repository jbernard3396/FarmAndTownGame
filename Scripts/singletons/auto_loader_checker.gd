extends Node


func _ready():
	EventBus.emit_signal('allSingletonsLoaded')
