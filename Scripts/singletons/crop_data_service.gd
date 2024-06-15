extends Node

var crops = []


func _ready():
	EventBus.connect("loaded", processLoadedCrop)

	
func processLoadedCrop(crop):
	if(!(crop is Crop)):
		return
	crops.append(crop)
	
func freshlyUnlockedCrops():
	var newCrops = crops.filter(func(crop): return crop.requiredLevel == PlayerContext.currentLevel)
	if (newCrops.is_empty()):
		return null
	return newCrops
