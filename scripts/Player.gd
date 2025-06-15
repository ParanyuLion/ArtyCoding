extends CharacterBody2D

var friction = -0.9
var drag = -0.0015
var wheel_base = 100  # Distance from front to rear wheel
var steering_angle = 13  # Amount that front wheel turns, in degrees
var engine_power = 500  # Forward acceleration force.
var slip_speed = 300  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction
var braking = -450
var max_speed_reverse = 250
var acceleration = Vector2.ZERO
#var velocity = Vector2
var steer_angle
#var students_on_board := 0
@export var dekku_exit_scene: PackedScene
@onready var exit_point = $ExitPoint
@onready var exit_target = $ExitTarget

func register_student():
	Global.student_on_bus += 1
	print("🚌 มีนักเรียนขึ้นรถแล้ว: ", Global.student_on_bus)

func leaving_student():
	if Global.student_on_bus <= 0:
		return
	
	Global.student_on_bus -= 1
	Global.student_left -= 1
	
	Global.score += 1
	print("🎒 นักเรียนลงรถ! เหลือ:", Global.student_on_bus)

	# สร้าง DekKUExit
	var dek_exit = dekku_exit_scene.instantiate()
	dek_exit.global_position = exit_point.global_position
	get_tree().current_scene.add_child(dek_exit)

	# สั่งให้เดินไปเป้าหมาย
	dek_exit.start_walking_to(exit_target.global_position)

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
