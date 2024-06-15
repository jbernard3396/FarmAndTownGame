extends Control

func _ready():
	EventBus.emit_signal('toolbarOpened', 'CropToolbar')
