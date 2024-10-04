extends RichTextLabel

func _ready():
	EventBus.connect("perksChanged", perksChanged)
	perksChanged()

func perksChanged():
	print('setting perks')
	var currentPerkPoints = PlayerContext.currentPerkPoints
	text = 'Perk Points: {a}'.format({"a": currentPerkPoints}) 
