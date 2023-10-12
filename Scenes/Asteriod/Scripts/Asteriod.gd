extends Area2D


var direction := Vector2.RIGHT

@export var speed = 200.0
@export var torque = 50.0


func _physics_process(delta: float) -> void:
	var velocity = speed * direction * delta
	global_position += velocity
	
	rotation_degrees += torque * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.destroy()
