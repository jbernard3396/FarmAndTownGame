class_name Fertilizer

var id: int

var name: String
var effectDescription: String
var cost: int
var order: int
var requiredLevel: int
var function: Variant

var sprite: SpriteFrames

var unlockSprites: SpriteFrames : get = getUnlockSprites
func getUnlockSprites():
	return sprite

var displayName = "testName": get = getName
func getName():
	return name
	
var description: String = 'test': get = getDescription
func getDescription():
	return 'costs {cost} gold to use, use it on a plot before planting to {effectDescription}'.format({'cost':cost, 'effectDescription':effectDescription})

func save():
	return{
		'id':id,
		'name':name,
		'effectDescription':effectDescription,
		'cost':cost,
		'order':order,
		'requiredLevel':requiredLevel,
		#figure out how to copy the function over??
	}
	
func load_data(data):
	if (!data):
		return
		
	id = data.id
	name = data.name
	effectDescription = data.effectDescription
	cost = data.cost
	order = data.order
	requiredLevel = data.requiredLevel
