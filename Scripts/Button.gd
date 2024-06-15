extends Control

@export var spriteImages: SpriteFrames
@export var buttonAreaWidth:int
@export var buttonAreaHeight:int
signal pressed
var spriteObject: AnimatedSprite2D
var buttonArea: Button


# Called when the node enters the scene tree for the first time.
func _ready():
	spriteObject = $'Sprite'
	spriteObject.sprite_frames = spriteImages
	buttonArea = $'ButtonArea'
	setButtonAreaSize()
	
	
func setButtonAreaSize():
	if(buttonAreaWidth == null):
		buttonAreaWidth = spriteImages.sprite_frames.get_frame_texture('default',0).get_width()
	if(buttonAreaHeight == null):
		buttonAreaHeight = spriteImages.sprite_frames.get_frame_texture('default',0).get_height()
	
	buttonArea.size.x = buttonAreaWidth
	buttonArea.size.y = buttonAreaHeight




func _on_button_area_button_up():
	spriteObject.frame = 0
	spriteObject.position.y-=2


func _on_button_area_button_down():
	spriteObject.frame = 1
	spriteObject.position.y+=2


func _on_button_area_pressed():
	emit_signal("pressed")
