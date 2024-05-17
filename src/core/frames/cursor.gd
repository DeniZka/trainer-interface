class_name UserCursor
extends Node2D

var tween : Tween = null

@export var user : String = "DUMMY":
	set(val):
		user = val
		$Label.text = val
		
func _ready():
	randomize()
	self.modulate = Color(randf(), randf(), randf(), 1.0)

func update_cursor(pos: Vector2):
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property($".", "position", pos, 0.3)
