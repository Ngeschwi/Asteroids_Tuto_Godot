extends Node2D
class_name Level


@export var asteriod_scene : PackedScene

var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var screen_size = Vector2(screen_width, screen_height)
var screen_center = screen_size / 2.0

@onready var border_rect = %BorderRect
@onready var asteriods_container = $Asteriods
@onready var gameover = %Gameover

@export var spawn_circle_radius : float = 350.0

@export var asteroid_direction_variance : float = 15.0


func spawn_asteroid_on_border():
	var angle = deg_to_rad(randf_range(0.0, 360.0))
	
	var dir_to_point = Vector2.RIGHT.rotated(angle)
	var spawn_position = screen_center + dir_to_point * spawn_circle_radius
	
	var top_left = border_rect.global_position
	var bottom_right = border_rect.global_position + border_rect.size
	spawn_position = spawn_position.clamp(top_left, bottom_right)
	
	
	var dir_to_center = spawn_position.direction_to(screen_center)
	
	var dir_rotation = randfn(0.0, deg_to_rad(asteroid_direction_variance))
	
	var asteroid_dir = dir_to_center.rotated(dir_rotation)
	var asteroid_size = randi_range(0, Asteroid.SIZE.size() - 1)
	spawn_asteriod(spawn_position, asteroid_dir, asteroid_size)


func spawn_asteriod(pos: Vector2, dir: Vector2, size: Asteroid.SIZE) -> void:
	var asteroid_intantiate = asteriod_scene.instantiate()
	asteriods_container.add_child.call_deferred(asteroid_intantiate)
	
	asteroid_intantiate.position = pos
	asteroid_intantiate.direction = dir
	
	asteroid_intantiate.size = size
	
	asteroid_intantiate.destroyed.connect(_on_asteroid_destroyed.bind(asteroid_intantiate))
	
	
func _on_asteroid_destroyed(asteroid: Asteroid) -> void:
	if asteroid.size > 0:
		var nb_spawn = randi_range(2, 3)
		
		for i in range(nb_spawn):
			var rot_deg = 90.0 + randfn(0.0, deg_to_rad(asteroid_direction_variance))
			var rdm_sign = [-1, 1].pick_random()
			var rot = deg_to_rad(rot_deg * rdm_sign)
			
			var dir = asteroid.direction.rotated(rot)
			
			spawn_asteriod(asteroid.global_position, dir, asteroid.size - 1)


func _on_spawn_timer_timeout() -> void:
	spawn_asteroid_on_border()


func _on_retry_button_pressed():
	get_tree().reload_current_scene()


func _on_player_destroyed():
	gameover.show()
