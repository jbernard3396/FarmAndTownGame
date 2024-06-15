extends Node

var perks = []

func _ready():
	EventBus.connect("loaded", processLoadedPerk)
	
func processLoadedPerk(perk):
	if(!(perk is Perk)):
		return
	perks.append(perk)
	
func freshlyUnlockedPerks():
	var newPerks = perks.filter(func(perk): return perk.requirements.any(func (req): return req.req.get_method() == 'levelRequirement' && req.arguments[0] == PlayerContext.currentLevel))
	if (newPerks.is_empty()):
		return null
	return newPerks
