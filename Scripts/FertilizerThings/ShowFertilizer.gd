extends Button

static func _on_pressed():
	EventBus.emit_signal('toolbarOpened', 'FertilizerToolbar')
