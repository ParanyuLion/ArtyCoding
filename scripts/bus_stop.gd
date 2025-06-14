extends Area2D

signal bus_arrived  # 🧨 ประกาศ signal

@onready var talai_bus = get_node("/root/main/TalaiBus")

func _ready():
	connect("body_entered", self._on_body_entered)

func _on_body_entered(body):
	if body == talai_bus:
		print("🚍 TalaiBus มาถึง BusStop แล้ว!")
		emit_signal("bus_arrived")  # 🔥 แจ้งทุกคนที่ connect ไว้
