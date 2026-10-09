extends Node2D


var speed = 300
var direction = Vector2(1,0)

func _physics_process(delta: float) -> void:
	var windows_position = Vector2(DisplayServer.window_get_position())
	windows_position += direction * speed * delta
	print(windows_position)
	DisplayServer.window_set_position(Vector2i(windows_position))
	var direction = Vector2(1,0)
	var screen_size = Vector2()
	var window_size = Vector2(200,200)
