extends Collectable
class_name Crop

var id: int

var name: String
var goldDrop: int
var xpDrop: int
var numFrames: int
var totalTimeToRipe: int
var cost: int
var order: int
var totalTimeToAdditionalRipe: int
var requiredLevel: int
var cropsPerHarvest: int
var numHarvests: int
var harvestSoFar: int

var sprites: SpriteFrames
var menuSprites: SpriteFrames

func collect():
	EventBus.emit_signal("harvested", self)

var unlockSprites: SpriteFrames : get = getUnlockSprites
func getUnlockSprites():
	return collectableSprites

var displayName = "testName": get = getName
func getName():
	return name
	
var harvestTime = "test time": get = getHarvestTime
func getHarvestTime():
	return Utils.convert_seconds_to_human_readable(totalTimeToRipe)
	
var description: String = 'test': get = getDescription
func getDescription():
	return 'costs {cost} gold to plant, ready to harvest in {harvestTime}, generates {gold} gold and {xp} xp per crop.  Will generate {crops} crops per harvest and can be harvested {numHarvests} times'.format({'cost':cost, 'harvestTime':harvestTime, 'gold':goldDrop, 'xp':xpDrop, 'crops':cropsPerHarvest, 'numHarvests':numHarvests})
	
func save():
#	print(instance_from_id(collectableSprites.get_instance_id()))
	var binaryCollectableSprites = var_to_bytes_with_objects(collectableSprites)
	var binarySprites = var_to_bytes_with_objects(sprites)
	return {
		'id': id,
		'name':name,
		'goldDrop':goldDrop,
		'xpDrop':xpDrop,
		'numFrames':numFrames,
		'totalTimeToRipe':totalTimeToRipe,
		'cost':cost,
		'order':order,
		'totalTimeToAdditionalRipe':totalTimeToAdditionalRipe,
		'requiredLevel':requiredLevel,
		'cropsPerHarvest':cropsPerHarvest,
		'numHarvests':numHarvests,
		'harvestSoFar':harvestSoFar,
		'collectableSprites':binaryCollectableSprites,
		'sprites':binarySprites
	}
	
func load_data(data):
	if (!data):
		return
	
	id = data.id
	name = data.name
	goldDrop = data.goldDrop
	xpDrop = data.xpDrop
	numFrames = data.numFrames
	totalTimeToRipe = data.totalTimeToRipe
	cost = data.cost
	order = data.order
	totalTimeToAdditionalRipe = data.totalTimeToAdditionalRipe
	requiredLevel = data.requiredLevel
	cropsPerHarvest = data.cropsPerHarvest
	numHarvests = data.numHarvests
	harvestSoFar = data.harvestSoFar
	collectableSprites = bytes_to_var_with_objects(JSON.parse_string(data.collectableSprites))
	sprites = bytes_to_var_with_objects(JSON.parse_string(data.sprites))
	
