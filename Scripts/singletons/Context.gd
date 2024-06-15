extends Node

var currentCrop: Crop
var currentFertilizer: Fertilizer

func _ready():
	EventBus.connect("cropChanged", populate_crop)
	EventBus.connect("fertilizerChanged", populate_fertilizer)
	EventBus.connect("itemSelected", processItemSelected)
	EventBus.connect("nothingSelected", clear_crop)


func populate_crop(crop):
	currentCrop = crop
	clear_fertilizer()
	
func populate_fertilizer(fertilizer):
	currentFertilizer = fertilizer
	clear_crop() 

func clear(_x):
		clear_crop()
		clear_fertilizer()

func processItemSelected(_unused):
	clear_crop()

func clear_crop():
	currentCrop = null
	
func clear_fertilizer():
	currentFertilizer = null
	


