class_name PlayerScript
extends CharacterBody3D


@export var SPEED : float
@export var JUMP_VELOCITY = 4.5
@export var isFreeMovement : bool
@export var mouseSensitivity : float = 0.006
@export var startChase : bool
@export var jumpscare : bool
@export var mrTime_anim : AnimationPlayer
@export var mrTime : Node3D
@export var animation_player : AnimationPlayer
@export var blackScreen : ColorRect
@export var text : Label

func _ready():
	startChase = false
	jumpscare = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if !startChase and !jumpscare:
		if isFreeMovement:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var direction;
		if isFreeMovement:
			direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		else:
			if input_dir.y < 0:
				direction = (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		floor_snap_length = 0.1
		apply_floor_snap()
		move_and_slide()
	elif jumpscare:
		Jumpscare()
	elif startChase:
		StartChase()
			
func StartChase():
		animation_player.play("lookBack")
		await animation_player.animation_finished
		#chaseAmbience.play()
		animation_player.play("LookForward")
		startChase = false
		SPEED = 3
			
func Jumpscare():
		#chaseAmbience.stop()
		%Camera3D.rotation.x = 0
		#jumpscareSound.play()
		animation_player.play("Jumpscare") 
		mrTime.position = Vector3(position.x + 2, mrTime.position.y, position.z)
		mrTime_anim.play("mixamo_com")
		await get_tree().create_timer(2.0).timeout
		mrTime_anim.stop()
		#jumpscareSound.stop()
		blackScreen.visible = true
		await get_tree().create_timer(0.7).timeout
		text.visible = true
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://Scenes/OldNeighborhood.tscn")
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if!startChase and !jumpscare:
			if isFreeMovement:
				rotate_y(-event.relative.x * mouseSensitivity)
			%Camera3D.rotate_x(-event.relative.y * mouseSensitivity)
			%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			
