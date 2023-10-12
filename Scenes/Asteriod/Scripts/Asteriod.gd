@tool
extends Area2D
class_name Asteroid


enum SIZE {
	SMALL,
	MEDIUM,
	BIG
}

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

@export var size : SIZE = SIZE.BIG:
	set(value):
		if value != size:
			size = value
			size_changed.emit()

var direction := Vector2.RIGHT

@export var speed = 200.0
@export var torque = 50.0

@export var asteroid_size_array : Array[AsteroidSize]


signal size_changed
signal destroyed


func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process(false)
	
	size_changed.connect(update_size)
	update_size()


func _physics_process(delta: float) -> void:
	var velocity = speed * direction * delta
	global_position += velocity
	
	rotation_degrees += torque * delta


func update_size() -> void:
	if not size in range(asteroid_size_array.size()):
		push_error("the given size " + str(size) + " value isn't a valid asteroid size index")
	
	var asteroid_size = asteroid_size_array[size]
	
	sprite.texture = asteroid_size.texture
	collision_shape.shape = asteroid_size.shape


func destroy() -> void:
	destroyed.emit()
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.destroy()
