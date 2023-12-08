@tool
extends Node2D

@export_range(0, 100, 1, "or_greater") var width : float = 20.0:
	set(val):
		width = val
		update_dims()
		queue_redraw()
@export_range(0, 100, 1, "or_greater") var height : float = 10.0:
	set(val):
		height = val
		update_dims()
		queue_redraw()
@export var color : Color = Color(1,1,1,1):
	set(val):
		color = val
		update_dims()
		queue_redraw()

var cir1_pos : Vector2 = Vector2(0,0)
var cir2_pos : Vector2 = Vector2(0,0)
var cir_rad : float = 1.0
var not_square: bool = true
var rect_dim : Rect2 = Rect2(0,0,2.0,2.0)
# Called when the node enters the scene tree for the first time.

func update_dims():
	#fast draw precalculate
	var w2 = width/2
	var h2 = height/2
	cir_rad = w2
	if height == width:
		not_square = false
	else:
		not_square = true
		if width > height:
			cir_rad = h2
			cir1_pos = Vector2(-w2+cir_rad, 0) #left
			cir2_pos = -cir1_pos #right
			rect_dim = Rect2(cir1_pos.x, -h2, cir2_pos.x * 2, height)
			
		if height > width:
			cir_rad = w2
			cir1_pos = Vector2(0, -h2+cir_rad) #top
			cir2_pos = -cir1_pos #bottom
			rect_dim = Rect2(-w2, cir1_pos.y, width, cir2_pos.y * 2)



func _ready():
	update_dims()
	pass # Replace with function body.


func _draw():
	if not_square:
		draw_circle(cir1_pos, cir_rad, color)
		draw_circle(cir2_pos, cir_rad, color)
		draw_rect(rect_dim, color)
	else:
		draw_circle(Vector2(0,0), cir_rad, color)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
