extends RichTextLabel

func _ready():
	EventBus.connect("goldChanged", gold_changed)
	gold_changed()

func gold_changed():
	var gold = PlayerContext.currentGold
	text = 'Gold: {a}'.format({"a": gold}) 
