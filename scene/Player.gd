extends CharacterBody2D


var speed = 300.0
var rotation_speed = 1.5
const JUMP_VELOCITY = -400.0
var rotation_direction = 0

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	velocity = transform.x * Input.get_axis("backward", "foward") * speed

func _physics_process(delta):
	get_input()
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
