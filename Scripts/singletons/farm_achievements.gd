extends Node

var achievementsDataLocation = 'res://Assets/Data/AchievementsData.json'

var achievementsData = {}
var achievements = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	achievementsData = JsonUtils.loadJsonFile(achievementsDataLocation)
	populateAchievements()
	EventBus.connect('loaded', processLoadedCrop)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func processLoadedCrop(crop):
	if(!(crop is Crop)):
		return
	populateAchievementFromCrop(crop)

func populateAchievements():
	for achievementKey in achievementsData:
		populateAchievement(achievementKey)
		
func populateAchievementFromCrop(crop):
	var listOfThingsToAchieve = [1, 10, 100, 1000, 10000]
	for numHarvested in listOfThingsToAchieve:
		var newAchievement = Achievement.new()
		var newRequirement = {}
		var pluralModifier = '' if numHarvested == 1 else 's'
		newAchievement.name = "Harvest{num}{cropName}{pluralModifier}".format({'num':numHarvested, 'cropName':crop.name, 'pluralModifier': pluralModifier})
		newAchievement.displayName = "Harvest {num} {cropName}{pluralModifier}".format({'num':numHarvested, 'cropName':crop.name, 'pluralModifier': pluralModifier})
		newAchievement.description = "Harvest {num} {cropName}{pluralModifier}".format({'num':numHarvested, 'cropName':crop.name, 'pluralModifier': pluralModifier})
		newAchievement.discipline = 'farm'
		newAchievement.claimed = 0
		#newAchievement.id = -1 #so I could do a thing where this class keeps a populated list of all ids ever used, and generates an unused id here, but I have a theory that ids are totally unuecesary
		newAchievement.requirements = []
		newRequirement.req = Callable(self, 'harvest')
		newRequirement.arguments = [numHarvested, crop.name]
		newAchievement.requirements.append(newRequirement)
		achievements[newAchievement.name] = newAchievement
		EventBus.emit_signal("loaded", newAchievement)
		
	
	

		
func populateAchievement(achievementKey):
	var achievement = achievementsData[achievementKey]
	var newAchievement = Achievement.new()
	var newRequirement
	for key in achievement:
		if key == "requirements":
			continue
		newAchievement[key] = achievement[key]
	newAchievement.claimed = 0
	newAchievement.discipline = "farm"
	newAchievement.requirements = []
	for requirementIndex in achievement["requirements"].size():
		var req = achievement["requirements"][requirementIndex].req
		var arguments = achievement["requirements"][requirementIndex].arguments
		newRequirement = Requirement.new()
		newRequirement.req = Callable(self, req)
		newRequirement.arguments = arguments
		newAchievement.requirements.append(newRequirement)
	achievements[achievementKey] = newAchievement
	EventBus.emit_signal("loaded", newAchievement)

func harvest(arguments):
	var num = arguments[0]
	var type = arguments[1]
	return (FarmStatistics.getNumCollectedByString(type) >= num)
