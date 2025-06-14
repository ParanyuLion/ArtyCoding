extends CharacterBody2D

var friction = -0.9
var drag = -0.0015
var wheel_base = 70  # Distance from front to rear wheel
var steering_angle = 15  # Amount that front wheel turns, in degrees
var engine_power = 800  # Forward acceleration force.
var slip_speed = 400  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction
var braking = -450
var max_speed_reverse = 250
var acceleration = Vector2.ZERO
#var velocity = Vector2
var steer_angle
#var students_on_board := 0

func register_student():
	Global.student_on_bus += 1
	print("🚌 มีนักเรียนขึ้นรถแล้ว: ", Global.student_on_bus)

func leaving_student():
	var leave_num = randi_range(0, Global.student_on_bus)
	if Global.student_on_bus >= 1:
		Global.student_on_bus -= leave_num
		Global.score += leave_num
	print("XXXXXXXX มีนักเรียนลงรถแล้ว: ", Global.student_on_bus)

	for i in range(3):
		var node_path = "main/DekKu" + str(i+1)

		if has_node(node_path):
			var dekku = get_node(node_path)
			dekku.visible = true
			dekku.modulate.a = 1

			# Ensure each Dekku object has an AnimationPlayer
			var anim_player = dekku.get_node("AnimationPlayer")
			if anim_player:
				anim_player.play("fade_in")
			else:
				print("AnimationPlayer not found in", node_path)
		else:
			print("Node not found:", node_path)

	return leave_num

func get_input():
	var turn = 0
	if Input.is_action_pressed("right"):
		turn += 1
	if Input.is_action_pressed("left"):
		turn -= 1
	steer_angle = turn * steering_angle

	if Input.is_action_pressed("foward"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("backward"):
		acceleration = transform.x * braking

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow

	if velocity.length() > slip_speed:
		traction = traction_fast

	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.lerp(new_heading * velocity.length(), traction)

	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	rotation = new_heading.angle()

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO

	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag

	if velocity.length() < 100:
		friction_force *= 3

	acceleration += drag_force + friction_force
	move_and_slide()
