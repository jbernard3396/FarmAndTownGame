extends Node

func fairMultiply(num, mult): #1, .95
	var value = num * mult #.95
	var floatValue = value - floor(value) #.95 - 0 = -.05
	value = floor(value) # 0
	if (randf() < abs(floatValue)):  #if d100 rolls under .05
		value += 1 # 0 += 1 = 1
	# else 0
	return value

# given a number of things, generates some subset of them
# selectFromList(3, 10) might return [2, 7, 8]
func selectFromList(numToSelect: int, totalThings: int) -> Array:
	var selectedIndices = []
	
	# Generate a list of all possible indices (0 to totalThings - 1)
	var allIndices = []
	for i in range(totalThings):
		allIndices.append(i)
	
	# Randomly select 'numToSelect' indices from 'allIndices'
	for i in range(numToSelect):
		if allIndices.size() == 0:
			break  # Avoid infinite loop if numToSelect is greater than totalThings
		var selectedIndex = randi() % allIndices.size()
		selectedIndices.append(allIndices[selectedIndex])
		allIndices.remove_at(selectedIndex)
	
	return selectedIndices
	
func convert_seconds_to_human_readable(seconds):
	
# Calculate hours, minutes, and remaining seconds
	var hours = int(seconds / 3600)
	var remainder = int(seconds % 3600)
	var minutes = int(remainder / float(60))
	var remaining_seconds = int(remainder % 60)

	# Construct the human-readable string
	var result = ""
	if hours > 0:
		result += str(hours) + " hour"
		if hours > 1:
			result += 's'
		# Add 'and' if there are minutes or remaining seconds
		if minutes > 0 or remaining_seconds > 0:
			result += " and "
	if minutes > 0:
		result += str(minutes) + " minute"
		if(minutes > 1):
			result += 's'
		# Add 'and' if there are remaining seconds
		if remaining_seconds > 0:
			result += " and "
	if remaining_seconds > 0 or (hours == 0 and minutes == 0):
		result += str(remaining_seconds) + " second"
		if remaining_seconds > 1:
			result += 's'

	return result
	

func intDiv(x, y):
	return int(floor(x)/floor(y))
	
func  makeCropShiny(crop: Crop):
	crop.sprites = makeSpriteFramesShiny(crop.sprites)
	#print(crop.sprites.get_frame_count('default'))
	
	crop.collectableSprites = makeSpriteFramesShiny(crop.collectableSprites)
	
func changeImageColor(image: Image):
	var height = image.get_height()
	var width = image.get_width()
	for x in range(width):
		for y in range(height):
			var originalPixelColor = image.get_pixel(x,y)
			if (originalPixelColor.a > .1):
				var halfAlphaColor = Color(originalPixelColor, .5)
				image.set_pixel(x,y, Color(1,1,.5).blend(halfAlphaColor))

func makeSpriteFramesShiny(sprites: SpriteFrames):
	var numImages = sprites.get_frame_count('default')
	var newSprites = SpriteFrames.new()
	for i in range(numImages):
		var currentTexture = sprites.get_frame_texture('default', i)
		var currentImage = Image.new()
		currentImage.copy_from(currentTexture.get_image())
		changeImageColor(currentImage)
		var newTexture = ImageTexture.new()
		newTexture.set_image(currentImage)
		newSprites.add_frame('default', newTexture)
	return newSprites
