extends Panel

@export var plotScene: PackedScene
@export var hoverMouse: Texture2D
@export var standardMouse: Texture2D

var affordable = false
var cost = 2
var spriteUp = false

var newPlotLabel : RichTextLabel
var newPlotSprite : AnimatedSprite2D

var newPlotX = 18
var newPlotY = 18

var xWidth = 30
var yWidth = 30

var plotsPerRow = Utils.intDiv(316-newPlotX,xWidth)
var currentTotalPlots = 0

var maxPlots = plotsPerRow * 3

var buttonPressed = false

var farmPlots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	newPlotLabel = $'ButtonGroup/Label'
	newPlotSprite = $'ButtonGroup/ButtonSprite'
	EventBus.connect('goldChanged', updateAffordable)
	EventBus.connect('gainNewPlot', processNewPlot)
	purchase_new_plot()
	updateAffordable()
	updateText()

func processNewPlot():
	#todo: I changed this from should pay true to should pay false because it sounds righter
	create_new_plot(false)

func _on_button_pressed():
	if(!affordable):
		return
	
	purchase_new_plot()
	
func create_new_plot(shouldPay):
	if(currentTotalPlots == maxPlots):
		return 
	var newPlot = plotScene.instantiate()
	add_child(newPlot)
	newPlot.position.x = newPlotX
	newPlot.position.y = newPlotY
	newPlot.setId(currentTotalPlots)
	farmPlots.append(newPlot)
	currentTotalPlots += 1
	if(shouldPay):
		pay()
	update_new_plot_location()
	updateCost()
	updateText()

func purchase_new_plot():
	create_new_plot(true)

	
func update_new_plot_location():
	newPlotX += xWidth
	if(currentTotalPlots%plotsPerRow == 0):
		newPlotX = 18
		newPlotY += yWidth
		

func updateAffordable():
	affordable = PlayerContext.currentGold >= cost
	setButtonSpriteUp()
	if(!affordable):
		setButtonSpriteDown()

func updateText():
	newPlotLabel.text = '+ Plot: {cost} gold'.format({"cost": cost})
	
func updateCost():
	cost = int(pow(cost, 1.1))+5
	updateAffordable()

func pay():
	if (currentTotalPlots == 1):
		return
	PlayerContext.gain_gold(-cost)


func _on_button_button_down():
	if(!affordable):
		return
	setButtonSpriteDown()
	buttonPressed = true

func _on_button_button_up():
	if(!buttonPressed):
		return
	if(affordable):
		setButtonSpriteUp()
	buttonPressed = false

func _on_button_mouse_entered():
	if(!affordable):
		return
	Input.set_custom_mouse_cursor(hoverMouse)


func _on_button_mouse_exited():
	Input.set_custom_mouse_cursor(standardMouse)
	
func setButtonSpriteUp():
	if(spriteUp):
		return
	newPlotSprite.frame = 0
	newPlotLabel.position.y -= 2
	spriteUp = true
	
func setButtonSpriteDown():
	if(!spriteUp):
		return
	newPlotSprite.frame = 1
	newPlotLabel.position.y += 2
	spriteUp = false
	
func save():
	return {
		"numPlots": currentTotalPlots
	}

func load_crop(data):
	if (!data):
		return

	for farmPlot in farmPlots:
		if farmPlot.getId() == data.id:
			farmPlot.load_data(data)
