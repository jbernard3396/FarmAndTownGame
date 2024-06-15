extends RichTextLabel

var wholeGroup
var expanded: bool = true
var tooltipBoxSprite: AnimatedSprite2D
var expandCollapseSprite: AnimatedSprite2D
var expandCollapseGroup: Control
var storedText:String

# Called when the node enters the scene tree for the first time.
func _ready():
	tooltipBoxSprite = $'../TooltipBoxSprite'
	expandCollapseSprite = $'../ExpandCollapse/ExpandCollapseSprite'
	expandCollapseGroup = $'../ExpandCollapse'
	wholeGroup = get_parent()
	EventBus.connect('itemSelected', handleItemSelected)
	EventBus.connect('nothingSelected', handleNothingSelected)

func handleItemSelected(item):
	storedText = '[b]'+item.displayName+'[/b]' + ': ' + item.description
	if(expanded):
		text= storedText
	
func handleNothingSelected():
	pass


func _on_expand_collapse_button_pressed():
	expanded = !expanded
	if(expanded):
		tooltipBoxSprite.show()
#		text = storedText
		show()
	if(!expanded):
		tooltipBoxSprite.hide()
#		storedText = text
#		text = ''
		hide()
	
	


func _on_expand_collapse_button_button_down():
	expandCollapseSprite.frame = 1
	expandCollapseSprite.position.y += 2


func _on_expand_collapse_button_button_up():
	expandCollapseSprite.frame = 0
	expandCollapseSprite.position.y -= 2
