extends Node

func multiplyGold(crop, percentage = 1.05):
	crop.goldDrop = Utils.fairMultiply(crop.goldDrop, percentage)
	
func multiplyExp(crop, percentage = 1.05):
	crop.xpDrop = Utils.fairMultiply(crop.xpDrop, percentage)
	
func multiplyCrops(crop, percentage = 1.02):
	crop.cropsPerHarvest = Utils.fairMultiply(crop.cropsPerHarvest, percentage)
	
func multiplyGrowTime(crop, percentage = .95):
	crop.totalTimeToRipe = Utils.fairMultiply(crop.totalTimeToRipe, percentage)
	crop.totalTimeToAdditionalRipe = Utils.fairMultiply(crop.totalTimeToAdditionalRipe, percentage)
	
func shiny(crop, percentage = 1):
	if(randf()>=percentage):
		return
	Utils.makeCropShiny(crop)
	crop.xpDrop *= 10
	crop.goldDrop *= 10
	
func gainGold():
	var currentLevel = PlayerContext.currentLevel
	PlayerContext.gain_gold(10 * currentLevel)
	
func gainXp():
	var currentLevel = PlayerContext.currentLevel
	PlayerContext.gain_exp(2 * currentLevel)
	
func gainPlot():
	EventBus.emit_signal('gainNewPlot')
