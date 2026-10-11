extends Node2D

var speed = 300 
var direction = Vector2(1,0)
var screen_size = Vector2()
var window_size = Vector2(200, 200)
var idle_timer = 0
var is_idling = false
var  is_dragging = false
var drag_offset = Vector2()
@onready var animated_sprite = $AnimatedSprite2D
@onready var area = $Area2D
func _ready():
	screen_size = Vector2(DisplayServer.screen_get_size())
	$AnimatedSprite2D.position = Vector2(75, 75)
	animated_sprite.play("default")
	area.input_event.connect(_on_area_input)
	print("SIGNAL CONNECTED")
	area.input_pickable = true
	area.collision_layer = 1

func _physics_process(delta: float) -> void:
	return
	if is_dragging:
		var mouse_pos = Vector2(DisplayServer.mouse_get_position())
		var new_win_pos = mouse_pos - drag_offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		return

	if is_idling:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idling = false
			speed = 300
			animated_sprite.play("default")

	var window_position = Vector2(DisplayServer.window_get_position())
	window_position += direction * speed * delta

	window_position.x = clamp(window_position.x, 0, screen_size.x - window_size.x)
	window_position.y = clamp(window_position.y, 0, screen_size.y - window_size.y)

	DisplayServer.window_set_position(Vector2i(window_position))

	if window_position.x <= 0 and direction.x < 0:
		direction.x = 1
		animated_sprite.flip_h = false
	elif window_position.x >= screen_size.x - window_size.x and direction.x > 0:
		direction.x = -1
		animated_sprite.flip_h = true

	if window_position.y <= 0 and direction.y < 0:
		direction.y = 1
	elif window_position.y >= screen_size.y - window_size.y and direction.y > 0:
		direction.y = -1

func maybe_idle():
	if randf() < 0.3:
		is_idling = true
		idle_timer = randf_range(1.0, 3.0)
		var r = randi() % 3
		if r == 0:
			animated_sprite.play("Idle")
			speed = 0

func _on_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				var mouse_pos = Vector2(DisplayServer.mouse_get_position())
				var win_pos = Vector2(DisplayServer.window_get_position())
				drag_offset = mouse_pos - win_pos
			else:
					is_dragging = false
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var space = get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = get_global_mouse_position()
		query.collide_with_areas = true
		var results = space.intersect_point(query)
		print("Areas under mouse: ", results.size())
