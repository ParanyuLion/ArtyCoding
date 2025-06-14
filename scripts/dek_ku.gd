extends CharacterBody2D

@onready var bus_stop = get_node("/root/MainScene/BusStop")  # Absolute path
@export var target_position: Vector2  # ตำแหน่งที่ DekKu จะเดินไป (เช่น หน้ารถ)

var walking := false
var speed := 100
#var velocity := Vector2.ZERO

func _ready():
	bus_stop = get_tree().get_nodes_in_group("bus_stops").front()
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
	if bus_stop:
		var is_here = bus_stop.connect("bus_arrived", self._on_bus_arrived)
		print(is_here)
		print("👦 DekKu พร้อมรับ signal แล้ว")
	else:
		print("❌ DekKu ยังไม่ได้เชื่อม bus_stop ใน Inspector")
		

	if walking:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		# Check if reached target
		if global_position.distance_to(target_position) < 5:
			walking = false
			velocity = Vector2.ZERO
			print("✅ DekKu: ขึ้นรถเรียบร้อยแล้ว")
