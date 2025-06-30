class_name PlayerScript
extends CharacterBody3D

@export var cheatMode : bool

@export var canWalk : bool
@export var SPEED : float
@export var JUMP_VELOCITY = 4.5
@export var isFreeMovement : bool

@export var canLook : bool
@export var head : Node3D
@export var mouseSensitivity : float = 0.006
@export var startChase : bool
@export var jumpscare : bool
@export var mrTime_anim : AnimationPlayer
@export var mrTime : Node3D
@export var animation_player : AnimationPlayer

@export var canRaycast : bool
@export var shotgun : Node3D
@export var canShoot : bool
@export var shotgun_prefab : Node3D
@onready var picked_up_shotgun = false
@export var youngGrandpa : Node3D
@export var grampsCollider : CollisionShape3D
@export var raycast : RayCast3D
@export var pickup_text : Label
@export var muzzle_flash_animation : AnimationPlayer
@export var muzzle_flash_model : AnimationPlayer
@export var shotgun_sound : AudioStreamPlayer2D
@export var muzzle_flash_light : OmniLight3D
var can_pickup = false
var target_gun = null

@export var blackScreen : ColorRect
@export var monolog : Label

func _ready():
	if cheatMode:
		SPEED = 25
		JUMP_VELOCITY = 10
		canShoot = true
		if shotgun != null:
			shotgun.visible = true
	else:
		canShoot = false
		if shotgun != null:
			shotgun.visible = false
	canLook = true
	canWalk = true
	startChase = false
	jumpscare = false
	if youngGrandpa != null:
		youngGrandpa.visible = false
		grampsCollider.disabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if canWalk:
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
		move_and_slide()
	if jumpscare:
		Jumpscare()
	if startChase:
		StartChase()
		
	if canRaycast:
		if raycast.is_colliding():
			var collider = raycast.get_collider()
		
			# Check if the object is the shotgun (by name or group)
			if collider.name == "Shotgun":  
				pickup_text.visible = true
				can_pickup = true
				target_gun = collider
			
			elif collider.name == "youngGrandpa":
				if Input.is_action_just_pressed("Shoot") and canShoot:
					shotgun_sound.play()
					muzzle_flash_animation.play("muzzle_flash_fire")
					muzzle_flash_model.play("fire")
					#await time(0.11)
					#blackScreen.visible = true
					FinalMonolog()
					
					
			else:
				pickup_text.visible = false
				can_pickup = false
				target_gun = null
		else:
			pickup_text.visible = false
			can_pickup = false
			target_gun = null

		# Press E to pick it up
		if can_pickup and Input.is_action_just_pressed("Interact"):
			pick_up_shotgun()
		else:
			pass

func pick_up_shotgun():
	canShoot = true
	picked_up_shotgun = true
	muzzle_flash_light.visible = true
	shotgun_prefab.visible = false
	shotgun.visible = true 
	pickup_text.visible = false
	can_pickup = false
	youngGrandpa.visible = true
	grampsCollider.disabled = false
			
func StartChase():
		canLook = false
		canWalk = false
		animation_player.play("lookBack")
		await animation_player.animation_finished
		#chaseAmbience.play()
		animation_player.play("LookForward")
		if animation_player.animation_finished:
			canWalk = true
			canLook = true
			startChase = false
			SPEED = 5
			
func Jumpscare():
		canLook = false
		canWalk = false
		#chaseAmbience.stop()
		%Camera3D.rotation.x = 0
		#jumpscareSound.play()
		animation_player.play("Jumpscare") 
		mrTime.position = Vector3(position.x + 2, mrTime.position.y, position.z)
		mrTime_anim.play("mixamo_com")
		await time(2.0)
		mrTime_anim.stop()
		#jumpscareSound.stop()
		blackScreen.visible = true
		await time(0.7)
		monolog.visible = true
		await time(1.5)
		get_tree().change_scene_to_file("res://Scenes/OldNeighborhood.tscn")
func _unhandled_input(event):
	if canLook:
		if event is InputEventMouseMotion:
			if isFreeMovement:
				rotate_y(-event.relative.x * mouseSensitivity)
			%Camera3D.rotate_x(-event.relative.y * mouseSensitivity)
			%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			
func time(seconds: float) -> void:
	if !is_inside_tree():
		await ready
	await get_tree().create_timer(seconds).timeout

func FinalMonolog():
	print("Monolog")
