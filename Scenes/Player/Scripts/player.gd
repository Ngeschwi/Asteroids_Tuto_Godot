extends CharacterBody2D
class_name Player

@export var projectile_scene : PackedScene

@export_range(0.0, 1.0) var accel_factor : float = 0.1
@export_range(0.0, 1.0) var rotation_accel_factor : float = 0.1

@export var max_speed : float = 200.0
var current_speed : float = 0

var direction := Vector2.ZERO
var last_direction := Vector2.ZERO


signal projectile_fire(projectile)


func _ready() -> void:
	pass


func _physics_process(_delta) -> void:
	move()
	rotate_toward_mouse()


func _input(event : InputEvent) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		last_direction = direction
	
	if  event.is_action_pressed("fire"):
		fire()


func fire() -> void:
	var projectile = projectile_scene.instantiate()
	projectile.transform = global_transform
	projectile_fire.emit(projectile)


func move() -> void:
	if  direction == Vector2.ZERO:
		current_speed = lerp(current_speed, 0.0, accel_factor)
	else:
		current_speed = lerp(current_speed, max_speed, accel_factor)
	
	velocity = last_direction * current_speed
	move_and_slide()


func rotate_toward_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	var angle = global_position.angle_to_point(mouse_pos)
	rotation = lerp_angle(rotation, angle, rotation_accel_factor)


func destroy() -> void:
	queue_free()
