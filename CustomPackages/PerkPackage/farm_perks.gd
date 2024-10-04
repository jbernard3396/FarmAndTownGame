extends Node

var perksDataLocation = 'res://Assets/Data/PerksData.json'

var perksData = {}
var perks = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	perksData = JsonUtils.loadJsonFile(perksDataLocation)
	populatePerks()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func populatePerks():
	for perkKey in perksData:
		populatePerk(perkKey)

		
func populatePerk(perkKey):
	var perk = perksData[perkKey]
	var newPerk = Perk.new()
	var newRequirement
	for key in perk:
		if key == "requirements":
			continue
		newPerk[key] = perk[key]
	newPerk.claimed = 0
	#todo:J this makes no sense when packaged
	newPerk.discipline = "farm"
	newPerk.function = Callable(Functions, newPerk.function)
	newPerk.requirements = []
	for requirementIndex in perk["requirements"].size():
		var req = perk["requirements"][requirementIndex].req
		var arguments = perk["requirements"][requirementIndex].arguments
		newRequirement = Requirement.new()
		newRequirement.req = Callable(self, req)
		newRequirement.arguments = arguments
		newPerk.requirements.append(newRequirement)
	perks[perkKey] = newPerk
	EventBus.emit_signal("loaded", newPerk)
	
func claim(perkName):
	for perkKey in perks:
		if perks[perkKey].displayName == perkName:
			var claimedPerk = perks[perkKey]
			if PlayerContext.currentPerkPoints <= 0:
				return
			print('claiming: {perk}'.format({'perk':perks[perkKey].displayName}))
			claimedPerk.claimed += 1
# TODO:J package up playerContext 
			PlayerContext.spendPerkPoints(1)
			applyInstantPerk(claimedPerk)
			
func applyInstantPerk(perk):
	if(perk.context != 'instant'):
		return
	perk.function.call()
	
func levelRequirement(arguments):
	var level = arguments[0]
	return PlayerContext.currentLevel >= level
	
#todo:J figure out how to package save nicely
func save():
	var saveArray = []
	for perk in perks:
		var perkObject = perks[perk]
		if perkObject.claimed > 0:
			saveArray.append(perks[perk].save())
	return saveArray
	
#todo:J figure out how to package load nicely
func load_data(data):
	if (!data):
		return

	for serializedPerk in data:
		var perk = getPerkByDisplayName(serializedPerk.displayName)
		perk.claimed = serializedPerk.claimed
		
func getPerkByDisplayName(displayName):
	for perk in perks:
		if perks[perk].displayName == displayName:
			return perks[perk]

