class_name UserCursor
extends Node2D

var tween : Tween = null

@export var user : String = "DUMMY":
	set(val):
		user = val
		$Label.text = val

func update_cursor(user_name: String, pos: Vector2):
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property($".", "position", pos, 0.3)
