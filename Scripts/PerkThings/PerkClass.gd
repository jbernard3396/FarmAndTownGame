class_name Perk

var discipline: String
var displayName: String
var requiredLevel: int
var description: String
var context: String
var function: Variant
var claimed: int
var requirements: Array # Type: Requirement
var unlockSprites: SpriteFrames = null

func save():
	if claimed < 1:
		return
	var serializedPerk = {
		"displayName":displayName,
		'claimed':claimed,
	}
	return serializedPerk

