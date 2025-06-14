extends Area2D

signal bus_arrived

@onready var talai_bus = get_node("/root/main/TalaiBus")
@onready var child_area = $ChildDetectionArea  # ต้องมี Area2D ชื่อ ChildDetectionArea
var leave_num

func _ready():
	connect("body_entered", self._on_body_entered)

func _on_body_entered(body):
	if body == talai_bus:
		print("🚍 TalaiBus มาถึงป้าย ", name)
		leave_num = talai_bus.leaving_student()

		var children = child_area.get_overlapping_bodies()
		for child in children:
			if child is CharacterBody2D and child.name.begins_with("Dek"):
				print("👦 แจ้ง DekKu: ", child.name)
				if child.has_method("_on_bus_arrived"):
					child._on_bus_arrived()
