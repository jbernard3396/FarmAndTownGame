extends Control

var plot: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	plot = $'Plot'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func setId(value):
	plot.id = value
	
func getId():
	return plot.id
	
func load_data(data):
	plot.load_data(data)
