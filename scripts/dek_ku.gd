extends CharacterBody2D

@export var speed := 100.0
@export var bus_stop_path: NodePath  # ตั้งค่าใน Inspector ให้ชี้ไปที่ BusStop

var target_position: Vector2
var walking := false
var bus_stop = null

func _ready():
	if bus_stop_path:
		bus_stop = get_node(bus_stop_path)
		if bus_stop:
			bus_stop.connect("bus_arrived", _on_bus_arrived)
			print("✅ DekKu: เชื่อม signal สำเร็จ")
		else:
			print("❌ DekKu: หา Node จาก path ไม่เจอ")
	else:
		print("❌ DekKu: ยังไม่ได้กำหนด bus_stop_path")

func _on_bus_arrived(bus_position: Vector2):
	print("👦 DekKu: ได้รับ signal แล้ว ตำแหน่งปลายทาง:", bus_position)
	target_position = bus_position
	walking = true

func _physics_process(delta):
	if walking:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		if global_position.distance_to(target_position) < 10:
			print("✅ DekKu: ขึ้นรถแล้ว")
			walking = false
			velocity = Vector2.ZERO
			queue_free()
