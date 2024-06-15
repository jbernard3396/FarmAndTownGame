extends Node2D

var farmPlots:Panel
var clock:Node
var timeToTick:float
# Called when the node enters the scene tree for the first time.
func _ready():
	farmPlots = $'Plots'
	clock = $'Clock'
	
	print('loading...')
	loadGame()
	print('finished loading!')

# when save is input perform save
func _process(_delta):
	if Input.is_action_just_pressed("Save"):
		save()
		
func loadGame():
	if not FileAccess.file_exists("user://savegame.save"):
		print("no save file to load, starting new file")
		return # Error! We don't have a save to load.
	
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	if (!load_meta_game_state(save_game)):
		return
	
	if (!load_farm_game_state(save_game)):
		return
		
	load_crop_game_state(save_game)
	clock.passTime(timeToTick);
	EventBus.emit_signal("gameLoaded")
	
	
	
func load_meta_game_state(save_game):
	# when there are other skills, this needs to be expanded
	var newJson = getNewLine(save_game)
	if(!newJson['skill']== 'Farming'):
		return false
	var lastSave = newJson['time'];
	var timePassed = Time.get_unix_time_from_system() - lastSave
	timeToTick = timePassed
	return true
	
func load_farm_game_state(save_game):
	var newJson = getNewLine(save_game)
	PlayerContext.load_data(newJson)
	var farmStatsJson = getNewLine(save_game)
	FarmStatistics.load_data(farmStatsJson)
	var achievements = getNewLine(save_game)
	AchievementDataService.load_data(achievements)
	var farmPerks = getNewLine(save_game)
	FarmPerks.load_data(farmPerks)
	return true
	
func load_crop_game_state(save_game):
	var newJson = getNewLine(save_game)
	load_plots(newJson)
	while save_game.get_position() < save_game.get_length():
		newJson = getNewLine(save_game)
		match newJson.savedObjectType:
			'Crop':
				load_crop(newJson)
	
func load_crop(cropJson):
	farmPlots.load_crop(cropJson)
	
	
	
	
func load_plots(data):
	if (!data):
		return
	
	#we get 1 for free
	for i in data.numPlots-1:
		EventBus.emit_signal('gainNewPlot')
	

func getNewLine(save_game):
	var json = JSON.new()
	var json_string = save_game.get_line()
	
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return null
	return json.get_data()

# we probably want to move this to a seperate file
func save():
	print("saving...")
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	#save meta game state
	save_meta_game_state(save_game)
	#save farm game state
	save_farm_game_state(save_game)
	#Save crop game state
	save_crop_game_state(save_game)
	print("save complete!")
	
func save_meta_game_state(save_game):
	var skillType = JSON.stringify({
		"skill": "Farming",
		"time": Time.get_unix_time_from_system()
		})
	save_game.store_line(skillType)
	
	
func save_farm_game_state(save_game):
	var playerContextNode = PlayerContext.save()
	var json_string = JSON.stringify(playerContextNode)
	save_game.store_line(json_string)
	
	var farmStatsNode = FarmStatistics.save()
	var farmState_string = JSON.stringify(farmStatsNode)
	save_game.store_line(farmState_string)
	
	var achievements = AchievementDataService.save()
	var achievements_string = JSON.stringify(achievements)
	save_game.store_line(achievements_string)
	
	var perks = FarmPerks.save()
	var perks_string = JSON.stringify(perks)
	save_game.store_line(perks_string)
	
func save_crop_game_state(save_game):
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
#	print(save_nodes)
#	print(save_nodes.size())
	for node in save_nodes:
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		save_game.store_line(json_string)
		
	var crop_nodes = get_tree().get_nodes_in_group("Crop")
	for node in crop_nodes:
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		save_game.store_line(json_string)
	
