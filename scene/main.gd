extends Node2D


func _ready():
	for child in get_node("main").get_children():
		print("Child node:", child.name)
