extends Node

var fertilizers = []


func _ready():
	EventBus.connect("loaded", processLoadedFertilizer)
	
func processLoadedFertilizer(fertilizer):
	if(!(fertilizer is Fertilizer)):
		return
	fertilizers.append(fertilizer)
	
func freshlyUnlockedFertilizers():
	var newFertilizers = fertilizers.filter(func(fertilizer): return fertilizer.requiredLevel == PlayerContext.currentLevel)
	if (newFertilizers.is_empty()):
		return null
	return newFertilizers
