extends AnimatedSprite2D

@export var bouncyCollectable : PackedScene

var ripenBar: ProgressBar

var cropIsPlanted = false
var plotIsFertilized = false
var isRipe = false

var id:int

var plantedCropSprite: AnimatedSprite2D
var plantedFertilizerSprite

var plantedFertilizer : Fertilizer
var plantedCrop : Crop
var totalTimeToRipe : int = 1
var xpDrop
var goldDrop
var numFrames = 1
var currentFrame

var lifeTime: int:
	get:
		return lifeTime
	set(value):
		lifeTime = value
		changeProgress.emit(float(lifeTime)/float(totalTimeToRipe))

signal changeProgress(progress)

func _ready():
	plantedCropSprite = $'PlantedCrop'
	plantedFertilizerSprite = $'PlantedFertilizer'
	ripenBar = $'../RipenBar'
	EventBus.connect("ticked", on_ticked)

func on_ticked():
	tickCrop()


func tickCrop():
	if(!cropIsPlanted):
		return
	lifeTime += 1
	determineFrame()
	
	if (lifeTime >= totalTimeToRipe):
		isRipe = true
		
func determineFrame():
	currentFrame = floor((float(lifeTime)/float(totalTimeToRipe))*numFrames)-1
	var currentCappedFrame = min(currentFrame, plantedCropSprite.sprite_frames.get_frame_count('default'))
	#print(currentCappedFrame)
	#print(plantedCropSprite.animation.get_basename())
	plantedCropSprite.frame = currentCappedFrame
	
func addFertilizer():
	if(!canFertilize()):
		return
	PlayerContext.gain_gold(-Context.currentFertilizer.cost)
	plotIsFertilized = true
	getFertilizerDetails()
	plantedFertilizerSprite.show()
	
func canFertilize():
	if(cropIsPlanted):
		return false
	if(Context.currentFertilizer == null):
		return false
	return PlayerContext.currentGold >= Context.currentFertilizer.cost
	
func plantCrop():
	if(!canPlant()):
		return
	PlayerContext.gain_gold(-Context.currentCrop.cost)
	cropIsPlanted = true
	ripenBar.show()
	plantedCropSprite.show()

	
	getCropDetails(Context.currentCrop, false)
	plantedCropSprite.position.y -= plantedCropSprite.sprite_frames.get_frame_texture('default', plantedCropSprite.sprite_frames.get_frame_count('default')-1).get_height()-16
	
func canPlant():
	if(Context.currentCrop == null):
		return false
	return PlayerContext.currentGold >= Context.currentCrop.cost
	
func getCropDetails(crop: Crop, fromLoad: bool):
	plantedCrop = Crop.new()
	plantedCrop.name = crop.name
	plantedCrop.totalTimeToRipe = crop.totalTimeToRipe
	plantedCrop.xpDrop = crop.xpDrop
	plantedCrop.goldDrop = crop.goldDrop
	plantedCrop.numFrames = crop.sprites.get_frame_count('default')
	plantedCrop.sprites = crop.sprites
	plantedCrop.cost = crop.cost
	plantedCrop.collectableSprites = crop.collectableSprites	
	plantedCrop.numHarvests = crop.numHarvests
	plantedCrop.harvestSoFar = crop.harvestSoFar
	plantedCrop.cropsPerHarvest = crop.cropsPerHarvest
	if(!fromLoad):
		applyFarmPerks(plantedCrop, 'crop')
		applyFertilizer(plantedCrop)
	totalTimeToRipe = plantedCrop.totalTimeToRipe
	xpDrop = plantedCrop.xpDrop
	goldDrop = plantedCrop.goldDrop
	numFrames = plantedCrop.sprites.get_frame_count('default')
	#print('num frames')
	#print(numFrames)
	plantedCropSprite.sprite_frames = plantedCrop.sprites


	
func getFertilizerDetails():
	var currentFertilizer = Context.currentFertilizer
	plantedFertilizer = Fertilizer.new()
	plantedFertilizer.name = currentFertilizer.name
	plantedFertilizer.effectDescription = currentFertilizer.effectDescription
	plantedFertilizer.requiredLevel = currentFertilizer.requiredLevel
	plantedFertilizer.cost = currentFertilizer.cost
	plantedFertilizer.sprite = currentFertilizer.sprite
	plantedFertilizer.function = currentFertilizer.function

func applyFertilizer(crop):
	if(!plotIsFertilized):
		return
	plantedFertilizer.function.call(crop)
	
func applyFarmPerks(crop, context):
	for perkKey in FarmPerks.perks:
		var currentPerk = FarmPerks.perks[perkKey]
		if(currentPerk.claimed == 0):
			continue
		if(currentPerk.context == context):
			for i in range(currentPerk.claimed):
#				var firstArgument = curentPerk.argument
				currentPerk.function.call(crop) #, firstArgument


func _on_button_pressed():
	if(!plotIsFertilized && !cropIsPlanted):
		addFertilizer()
	if(!cropIsPlanted):
		plantCrop()
	if(cropIsPlanted && isRipe):
		harvestCrop()
		
func harvestCrop():
	checkHarvests()
	spawnCollectableCrops()

func spawnCollectableCrops():
	for i in plantedCrop.cropsPerHarvest:
		spawnCollectableCrop()

func spawnCollectableCrop():
	var bouncyCrop = bouncyCollectable.instantiate()
	add_child(bouncyCrop)
	bouncyCrop.position = Vector2.ZERO
	bouncyCrop.z_index += 39
	bouncyCrop.collectableItem = plantedCrop
	bouncyCrop.collectionPosition.x = to_local(get_viewport_rect().size).x
	bouncyCrop.collectionPosition.y = to_local(get_viewport_rect().size).y

	bouncyCrop.start()

func replantCrop():
	ripenBar.show()
	isRipe = false
	lifeTime = 0 
	determineFrame()
	
func resetCrop():
	cropIsPlanted = false
	plotIsFertilized = false
	plantedCropSprite.hide()
	plantedFertilizerSprite.hide()
	isRipe = false
	lifeTime = 0 
	ripenBar.hide()
	determineFrame()
	
	
func checkHarvests():
	plantedCrop.harvestSoFar += 1
	if(plantedCrop.harvestSoFar >= plantedCrop.numHarvests):
		resetCrop()
	else:
		replantCrop()
		
		
func save():
	var cropDataObject = {
		'savedObjectType':'Crop',
		'id':id,
		'cropIsPlanted': cropIsPlanted,
		'plotIsFertilized': plotIsFertilized,
		'isRipe':isRipe,
		'totalTimeToRipe': totalTimeToRipe,
		'xpDrop': xpDrop,
		'goldDrop': goldDrop,
		'numFrames':numFrames,
		'currentFrame':currentFrame
	}
	if (plantedCrop != null):
		var crop = plantedCrop.save()
		cropDataObject['crop'] = crop
	if(plantedFertilizer != null):
		var fertilizer = plantedFertilizer.save()
		cropDataObject['fertilizer'] = fertilizer
	return cropDataObject
	
func load_data(data):
	if (!data):
		return

	id = data.id
	cropIsPlanted = data.cropIsPlanted
	plotIsFertilized = data.plotIsFertilized
	isRipe = data.isRipe
	xpDrop = data.xpDrop
	goldDrop = data.goldDrop
	numFrames = data.numFrames
	currentFrame = data.currentFrame
	if (data.crop):
		var newCrop = Crop.new()
		newCrop.load_data(data.crop)
		getCropDetails(newCrop, true)
		ripenBar.show()
		plantedCropSprite.show()
	plantedFertilizer = Fertilizer.new()
#	plantedFertilizer.load_data(data.fertilizer)
