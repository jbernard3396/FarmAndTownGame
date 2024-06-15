extends Node

var currentGold: int = 0
var currentExp: int = 0
var currentLevel: int = 1
var expToNextLevel: int = 10
var currentPerkPoints: int = 0

func _ready():
	EventBus.connect("harvested", on_harvest)

func on_harvest(crop):
	gain_exp(crop.xpDrop)
	gain_gold(crop.goldDrop)

func gain_exp(expGained):
	currentExp += expGained
	while (currentExp >= expToNextLevel):
		level_up()
	EventBus.emit_signal("expChanged")
		
func level_up():
	currentExp -= expToNextLevel
	currentLevel += 1
	currentPerkPoints += 1
	EventBus.emit_signal("leveledUp")
	EventBus.emit_signal("perksChanged")
	increase_exp_to_next_level()

func spendPerkPoints(num):
	currentPerkPoints -= num
	if(currentPerkPoints < 0): 
		currentPerkPoints = 0
	EventBus.emit_signal("perksChanged")

func increase_exp_to_next_level():
	var nextExpFloat: float
	nextExpFloat = expToNextLevel * 1.2
	expToNextLevel = floor(nextExpFloat)
	
func gain_gold(goldGained):
	currentGold += goldGained
	EventBus.emit_signal("goldChanged")
	
func save():
	var save_dict = {
		"gold": currentGold,
		"exp": currentExp,
		"level": currentLevel,
		"currentPerkPoints": currentPerkPoints,
		"expToNextLevel": expToNextLevel
	}
	return save_dict

func load_data(save_dict):
	var gold = save_dict['gold']
	gain_gold(gold)
	currentLevel = save_dict['level']
	var ex_p = save_dict['exp']
	gain_exp(ex_p)
	currentPerkPoints = save_dict['currentPerkPoints']
	expToNextLevel = save_dict['expToNextLevel']
