extends Node2D

var speed = 300 
var direction = Vector2(1,0)
var screen_size = Vector2()
var window_size = Vector2(200,200)
var window_position = Vector2()
var idle_timer = 0.0
var is_idling = false
@onready var animated_sprite = $AnimatedSprite2D

func _ready(): 
	screen_size = Vector2(DisplayServer.screen_get_size())
	
	# 1. هذا السطر يضمن بقاء الشخصية في منتصف النافذة تماماً
	animated_sprite.position = window_size / 2
	
	# 2. هذا السطر يقوم بتكبير حجم الشخصية 3 مرات
	animated_sprite.scale = Vector2(5, 5)
	
	animated_sprite.play("Walk_Right")

func _physics_process(delta: float) -> void: 
	window_position = Vector2(DisplayServer.window_get_position()) 
	window_position += direction * speed * delta 
	print(window_position) 
	
	window_position.x = clamp(window_position.x, 0, screen_size.x - window_size.x) 
	window_position.y = clamp(window_position.y, 0, screen_size.y - window_size.y) 
	
	DisplayServer.window_set_position(Vector2i(window_position))
	if window_position.x <= 0 or window_position.x >= screen_size.x - window_size.x:
		direction.x *= -1
		animated_sprite.flip_h = !animated_sprite.flip_h
	if window_position.y <= 0 or window_position.y >= screen_size.y - window_size.y:
		direction.y *= -1
