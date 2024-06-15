extends Area2D

var floorY: float
var speedY: float
var speedX: float
var thisGravity: float = .25
var friction:float = .95
var bounceLoss:float= 1

var bouncing = true
var collecting = false

var collectionPosition: Vector2
var collectionSpeed: float = 5

var collectableItem : Collectable

var viewportRectTopLeft: Vector2
var viewportRectBottomRight: Vector2

var timeAlive = 0

var parent

func _ready():
	get_tree().paused = true

	

func start():
	vetConditions()
	disablePhysics()
	setStartValues()
	
	

func _process(delta):
	incrementTimeAlive(delta)
	bounce()
	collect(delta)
	
func incrementTimeAlive(delta):
	timeAlive += delta

func vetConditions():
	if collectionPosition == null:
		print("error, no collection position")
	if collectableItem == null:
		print("error, no collectable Item")

func disablePhysics():
	set_physics_process(false)

func setStartValues():
	var floorVariation = randf_range(0,30)
	floorY = position.x + floorVariation
	
	speedX = randf_range(-1, 2)
	speedY = randf_range(-4, -2.5)
	
	viewportRectTopLeft = Vector2(0,0)
	viewportRectBottomRight = get_viewport_rect().size
	parent = get_parent()
	get_tree().paused = false
	
	$'AnimatedSprite2D'.sprite_frames = collectableItem.collectableSprites

	
func bounce():
	if(!bouncing):
		return
	updateValues()
	move()
	
func updateValues():
	if(abs(speedY)<1 and abs(position.y - floorY)<1):
		speedY = 0
		speedX = 0
		bouncing = false
		return
	speedX *= friction
	speedY *= friction
	speedY += thisGravity
	
func move():
	position.x += speedX
	position.y += speedY
	if(position.y > floorY):
		position.y = floorY
		speedY = -speedY*bounceLoss
	
	if(position.y == parent.to_local(Vector2.ZERO).y):
		speedY = 0
		
	position = parent.to_local(parent.to_global(position).clamp(viewportRectTopLeft, viewportRectBottomRight))

	
	
	
	


func collect(delta):
	if(!collecting):
		return
	position = position.lerp(collectionPosition, delta*collectionSpeed)
	if (abs(position - collectionPosition).length()<1):
		performCollection()
	

func performCollection():
	collectableItem.collect()
	queue_free()


func _on_mouse_entered():
	if (timeAlive <= .2):
		return
	bouncing = false
	collecting = true
	
