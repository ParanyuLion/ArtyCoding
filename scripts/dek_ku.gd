extends CharacterBody2D

@onready var bus_stop = get_node("../Bus_stop")  # Absolute path
@export var target_position: Vector2  # ตำแหน่งที่ DekKu จะเดินไป (เช่น หน้ารถ)
@onready var talai_bus = get_node("/root/main/TalaiBus")


var walking := false
var speed := 100
#var velocity := Vector2.ZERO

func _ready():
	if bus_stop:
		var is_here = bus_stop.connect("bus_arrived", self._on_bus_arrived)
		print(is_here)
		print("👦 DekKu พร้อมรับ signal แล้ว")
	else:
		print("❌ DekKu ยังไม่ได้เชื่อม bus_stop ใน Inspector")

func _on_bus_arrived():
	print("👦 DekKu: ได้รับ signal แล้ว! เริ่มเดินไปที่รถ")
	walking = true

func _physics_process(delta):
	if walking:
		var collision = move_and_collide(velocity*delta)
		var bus_pos = talai_bus.global_position  # อัปเดตทุกเฟรม
		var direction = (bus_pos - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		if collision:
			var collider = collision.get_collider()
			if collider is CharacterBody2D:
				print("✅ DekKu: ถึงรถแล้ว")
				walking = false
				velocity = Vector2.ZERO
				queue_free()
