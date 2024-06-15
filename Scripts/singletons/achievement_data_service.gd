extends Node

var achievements = []


func _ready():
	EventBus.connect("loaded", processLoadedAchievement)
	EventBus.connect("harvested", updateAchievements)

	
func processLoadedAchievement(achievement):
	if(!(achievement is Achievement)):
		return
	achievements.append(achievement)
	
func updateAchievements(_name):
	var newAchievements = achievements.filter(func(achievement): return isAchievementUnclaimed(achievement) && isAchievementAchieved(achievement))
	if (newAchievements.is_empty()):
		return null
	else:
		newAchievements.map(func(achievement): achievement.claimed = 1)
		#this needs to loop through them
		for newAchievement in newAchievements:
			EventBus.emit_signal('achieved', newAchievement)
	return newAchievements

func isAchievementUnclaimed(achievement):
	if (achievement.claimed == 0):
		return true
	return false
	
func isAchievementAchieved(achievement):
	if (achievement.requirements.all(func(requirement): return requirement.req.call(requirement.arguments))):
		return true
	return false


func save():
	var saveArray = []
	for achievement in achievements:
		if achievement.claimed > 0:
			saveArray.append(achievement.save())
	return saveArray
	
	
func load_data(data):
	if (!data):
		return

	for serializedAchievement in data:
		var achievement = getAchievmentByName(serializedAchievement.name)
		achievement.claimed = serializedAchievement.claimed
		
func getAchievmentByName(achievementName):
	for achievement in achievements:
		if achievement.name == achievementName:
			return achievement
	
		
		
