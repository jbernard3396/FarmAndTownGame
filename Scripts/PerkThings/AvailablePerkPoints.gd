extends RichTextLabel

func _ready():
	EventBus.connect("perksChanged", perksChanged)
	perksChanged()

func perksChanged():
	print('setting perks')
	var perks = PlayerContext.currentPerkPoints
	text = 'Perk Points: {a}'.format({"a": perks}) 
