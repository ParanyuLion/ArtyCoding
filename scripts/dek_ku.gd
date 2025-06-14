extends CharacterBody2D

@onready var talai_bus = get_node("/root/main/TalaiBus")
@onready var anim = $AnimatedSprite2D

var walking := false
var speed := 100
#var velocity := Vector2.ZERO
var last_direction := "down"

func _ready():
	print("👦 DekKu: พร้อมรอฟังสัญญาณจากป้ายรถเมล์")

func _on_bus_arrived():
	print("👦 ได้รับสัญญาณจาก BusStop → เริ่มเดินไปขึ้นรถ")
	walking = true

func _physics_process(delta):
	if walking:
		var direction = (talai_bus.global_position - global_position).normalized()
		velocity = direction * speed

		play_walk_animation(direction)

		var collision = move_and_collide(velocity * delta)
		if collision and collision.get_collider() == talai_bus:
			print("✅ DekKu: ถึงรถแล้ว")
			walking = false
			velocity = Vector2.ZERO
			anim.stop()
			queue_free()

func play_walk_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim.play("walk_right")
			last_direction = "right"
		else:
			anim.play("walk_left")
			last_direction = "left"
	else:
		if dir.y > 0:
			anim.play("walk_down")
			last_direction = "down"
		else:
			anim.play("walk_up")
			last_direction = "up"
