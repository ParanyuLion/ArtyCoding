extends Node2D


var is_active = false

func appear_from_left(start_position: Vector2):
	position = start_position
	visible = true
	modulate.a = 1.0
	is_active = true
	$AnimationPlayer.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		modulate.a = 0.0
		is_active = false
		visible = false

