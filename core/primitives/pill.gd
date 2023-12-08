@tool
class_name Pill extends Polygon2D

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

@export_range(0,100,0.1,"or_greater") var roundness : float = 10:
	set(val):
		roundness = val
		update_dims()
		queue_redraw()

@export_range(1, 32, 1, "or_greater") var smooth : float = 10:
	set(val):
		smooth = val
		update_dims()
		queue_redraw()

var real_roundness : float
var cir1_pos : Vector2 = Vector2(0,0)
var cir2_pos : Vector2 = Vector2(0,0)
var cir_rad : float = 1.0
var not_square: bool = true
var rect_dim : Rect2 = Rect2(0,0,2.0,2.0)
# Called when the node enters the scene tree for the first time.
var pure_rect: bool = false
var pure_circle: bool = false
var points : PackedVector2Array
var colors : PackedColorArray = PackedColorArray([Color(1,1,1,1)])
const v_reflects : Array = [Vector2(0,1), Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0)] 


func add_qround(angleFrom: float, center: Vector2, radius: float):
	var step = (PI*0.5)/smooth
	var anglePoint = angleFrom
	for i in range(smooth):
		points.push_back(center + Vector2( cos( anglePoint ), sin( anglePoint ) )* radius)
		anglePoint = anglePoint + step 
	points.push_back(center + Vector2( cos( anglePoint ), sin( anglePoint ) )* radius)


func update_dims():
	#fast draw precalculate
	var w2 = width * 0.5
	var h2 = height * 0.5
	points.clear()
	#check if pure shapes
	if roundness == 0.0: #pure rect
		points.push_back(Vector2(-w2, h2))
		points.push_back(Vector2(w2, h2))
		points.push_back(Vector2(w2, -h2))
		points.push_back(Vector2(-w2, -h2))
	else:

		#cal roundness
		real_roundness = roundness
		if real_roundness > w2:
			real_roundness = w2
		if real_roundness > h2:
			real_roundness = h2
		
		var in_vec = Vector2(w2, h2) - Vector2(real_roundness, real_roundness)	
		for i in range(4):
			add_qround(i*PI*0.5, in_vec, real_roundness)
			in_vec = in_vec.reflect(v_reflects[i] )
	polygon = points

func _ready():
	update_dims()
