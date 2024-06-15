extends Control

@export var spriteImages: SpriteFrames
@export var pixelsToLowerOnPress:int = 2
@export var buttonAreaWidth:int
@export var buttonAreaHeight:int

#@export_group("buttonText")
@export var text:String
@export var textOffset:int = -4
@export var pixelsToLowerTextOnPress:int = 2

signal pressed
var spriteObject: AnimatedSprite2D
var buttonArea: Button
var buttonText: RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	spriteObject = $'Sprite'
	spriteObject.sprite_frames = spriteImages
	buttonArea = $'ButtonArea'
	buttonText = $'ButtonText'
	setButtonAreaSize()
	setText()
	
	
func setButtonAreaSize():
	if(buttonAreaWidth == null):
		buttonAreaWidth = spriteImages.sprite_frames.get_frame_texture('default',0).get_width()
	if(buttonAreaHeight == null):
		buttonAreaHeight = spriteImages.sprite_frames.get_frame_texture('default',0).get_height()
	
	buttonArea.size.x = buttonAreaWidth
	buttonArea.size.y = buttonAreaHeight
	
func setText():
	if (text == ''):
		return
	text = "[center]{textToCenter}[/center]".format({"textToCenter":text})
	buttonText.size.x = buttonAreaWidth*4
	buttonText.size.y = buttonAreaHeight*4
	buttonText.text = text
	buttonText.position.y += textOffset
	var textHeight = Utils.intDiv(buttonText.get_content_height(),4)
	print(textHeight)
	if(textHeight <= buttonAreaHeight):
		var heightDifference = buttonAreaHeight - textHeight
		buttonText.position.y += Utils.intDiv(heightDifference,2)
		


func _on_button_area_button_up():
	spriteObject.frame = 0
	spriteObject.position.y-=pixelsToLowerOnPress
	buttonText.position.y-=pixelsToLowerTextOnPress


func _on_button_area_button_down():
	spriteObject.frame = 1
	spriteObject.position.y+=pixelsToLowerOnPress
	buttonText.position.y+=pixelsToLowerTextOnPress


func _on_button_area_pressed():
	emit_signal("pressed")
