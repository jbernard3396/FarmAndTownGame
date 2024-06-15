extends Node

var cropsCollected = {}

func _ready():
	EventBus.connect('harvested', processHarvest)
	EventBus.connect('loaded', loadCrop)

func processHarvest(crop):
	cropsCollected[crop.name] += 1
	#print('harvest: {cropname} {num} times'.format({"cropname":crop.name, "num":cropsCollected[crop.name]}))
	
func loadCrop(crop):
	if !crop is Crop:
		return
	cropsCollected[crop.name] = 0
	
func getNumCollected(crop):
	return getNumCollectedByString(crop.name)
	
func getNumCollectedByString(cropName):
	return cropsCollected[cropName]
	
func save():
	return cropsCollected

func load_data(farmStatsJson):
	if(!farmStatsJson):
		return
	cropsCollected = farmStatsJson
	
