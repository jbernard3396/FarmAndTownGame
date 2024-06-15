extends Control

@export var achievementScene: PackedScene

var pageNumberLabel: RichTextLabel

var panelName = 'AchievementPanel'
var items = []
var achievementObjects = []
var currentPage:int = 0
var lastPage: int = 0
var rows:int = 4
var columns:int = 2
var rowStart:int = 5
var colStart:int = 5
var rowThickness:int = 22
var colThickness:int = 121

# Called when the node enters the scene tree for the first time.
func _ready():
	pageNumberLabel = $'PageNumber'
	visible = false
	EventBus.connect('loaded', updateExisting)
	EventBus.connect('achieved', updateAchieved)
	EventBus.connect('opened', closePanel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("ShowAchievements")):
		currentPage = 0
		displayCurrentPage()
		if(!visible):
			EventBus.emit_signal("opened", panelName)
			visible = true
		else: 
			EventBus.emit_signal("opened", '')

		
func updateExisting(achievement):
	if(!(achievement is Achievement)):
		return
	items.append(achievement)
	achievementObjects.append(instantiateAchievementObject(achievement))
	updateLastPage()

func updateAchieved(achievement):
	var itemIndex = items.find(achievement)

	achievementObjects[itemIndex].achieved()
	
func closePanel(panelOpened):
	if(panelOpened != panelName):
		hide()

func updateLastPage():
	lastPage = Utils.intDiv(achievementObjects.size()-1,(columns*rows))

func instantiateAchievementObject(achievement):
	var newAchievmentObject = achievementScene.instantiate()
	add_child(newAchievmentObject)
	newAchievmentObject.setAchivement(achievement)
	return newAchievmentObject
	
func displayCurrentPage():
	hideAll()
	pageNumberLabel.text = '{currentPage}/{lastPage}'.format({'currentPage':currentPage+1, 'lastPage':lastPage+1})
	var firstItem = currentPage*rows*columns
	for row in range(rows):
		for col in range(columns):
			var currentIndex = firstItem + col+(row*columns)
			if(currentIndex >= achievementObjects.size()):
				return
			var currentAchievement = achievementObjects[currentIndex]
			currentAchievement.position.x = colStart+(col*colThickness)
			currentAchievement.position.y = rowStart+(row*rowThickness)
			currentAchievement.show()


func hideAll():
	for i in achievementObjects.size():
		achievementObjects[i].hide()



func _on_page_left_button_pressed():
	currentPage -= 1
	currentPage = max(0, currentPage)
	displayCurrentPage()


func _on_page_first_button_pressed():
	currentPage = 0
	displayCurrentPage()


func _on_page_last_button_pressed():
	currentPage = lastPage
	displayCurrentPage()


func _on_page_right_button_pressed():
	currentPage += 1
	currentPage = min(lastPage, currentPage)
	displayCurrentPage()
