extends Node2D
class_name Level


@export var asteriod_scene : PackedScene

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var screen_size = Vector2(screen_width, screen_height)
var screen_center = screen_size / 2.0

@onready var border_rect = %BorderRect
@onready var asteriods_container = $Asteriods

@export var spawn_circle_radius : float = 350.0

@export var asteroid_direction_variance : float = 15.0


func spawn_asteriod() -> void:
	var spawn_position = get_spawn_position()
	
	instantiate_asteroid(spawn_position)


func get_spawn_position() -> Vector2:
	var angle = deg_to_rad(randf_range(0.0, 360.0))
	
	var dir_to_point = Vector2.RIGHT.rotated(angle)
	var spawn_position = screen_center + dir_to_point * spawn_circle_radius
	
	var top_left = border_rect.global_position
	var bottom_right = border_rect.global_position + border_rect.size
	spawn_position = spawn_position.clamp(top_left, bottom_right)
	
	return spawn_position


func instantiate_asteroid(spawn_position) -> void:
	var asteriod = asteriod_scene.instantiate()
	asteriods_container.add_child(asteriod)
	
	asteriod.position = spawn_position
	
	var dir_to_center = spawn_position.direction_to(screen_center)
	
	var dir_rotation = randfn(0.0, asteroid_direction_variance)
	asteriod.direction = dir_to_center.rotated(deg_to_rad(dir_rotation))


func _input(event) -> void:
	if event.is_action_pressed("ui_accept"):
		spawn_asteriod()
