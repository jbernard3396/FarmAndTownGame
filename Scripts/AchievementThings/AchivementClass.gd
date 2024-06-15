class_name Achievement

var id: int
var name: String
var discipline: String
var displayName: String
var description: String
var claimed: int
var requirements: Array # Type: Requirement
var sprite: SpriteFrames = null

func save():
	if claimed < 1:
		return 
	var serializedAchievement = {
		"id":id,
		"name":name,
		'claimed':claimed,
	}
	return serializedAchievement


