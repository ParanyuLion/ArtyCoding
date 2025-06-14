extends CharacterBody2D

@export var walk_speed := 40
var target_position: Vector2
var walking := false
@onready var anim = $AnimatedSprite2D
var last_direction := "down"

func start_walking_to(pos: Vector2):
	target_position = pos
	walking = true

func play_walk_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim.play("right")
			last_direction = "right"
		else:
			anim.play("left")
			last_direction = "left"
	else:
		if dir.y > 0:
			anim.play("down")
			last_direction = "down"
		else:
			anim.play("up")
			last_direction = "up"
func _physics_process(delta):
	if walking:
		var direction = (target_position - global_position).normalized()
		velocity = direction * walk_speed
		play_walk_animation(direction)
		move_and_slide()

		if global_position.distance_to(target_position) < 5:
			walking = false
			velocity = Vector2.ZERO
			queue_free() # ถ้าอยากให้หายไปเมื่อถึงเป้าหมาย
