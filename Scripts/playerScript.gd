class_name PlayerScript
extends CharacterBody3D

@onready var killedGrandpa = false
@export var mainShader : ColorRect
@export var mrTime_growl : AudioStreamPlayer2D
@export var cheatMode : bool
@export var isBeatingNow : bool
@export var fadeAnimation : AnimationPlayer
@export var fadeScren : ColorRect
@export var objectiveOne : Label
@export var objectiveTwo : Label
@export var objectivesPanel : ColorRect
@export var monologLabels : Array[Label]

var deltaTime
var previous_position
var yaw := deg_to_rad(90.0)  # Starting rotation
@export var canWalk : bool
@export var SPEED : float
@export var JUMP_VELOCITY = 4.5
@export var isFreeMovement : bool
@export var walkSound : AudioStreamPlayer2D
@export var jumpSound : AudioStreamPlayer2D
@export var landSound : AudioStreamPlayer2D
@onready var transformBasis

@export var canLook : bool
@export var head : Node3D
@export var mouseSensitivity : float = 0.006
@export var startChase : bool
@export var jumpscare : bool
@export var jumpscareSound : AudioStreamPlayer2D
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
	previous_position = global_transform.origin
	yaw = rotation.y  # Sync with scene setup
	transformBasis = transform.basis
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
	deltaTime = delta
	
	if not canWalk:
		walkSound.stop()
		
	
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
		if canWalk:
			if isFreeMovement:
				if is_on_floor() and input_dir != Vector2.ZERO:
					if not walkSound.playing:
						walkSound.play()
				else:
					if walkSound.playing:
						walkSound.stop()

				direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			else:
				if input_dir.y < 0 and is_on_floor():
					if not walkSound.playing:
						walkSound.play()
				else:
					if walkSound.playing:
						walkSound.stop()
				direction = (transformBasis * Vector3(0, 0, input_dir.y)).normalized()
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
			
			if global_transform.origin.distance_to(previous_position) < 0.001 and input_dir != Vector2.ZERO:
				walkSound.stop()
			move_and_slide()
		previous_position = global_transform.origin
		
		CheckDistance()
	
	if jumpscare:
		Jumpscare()
	if startChase:
		StartChase()
		
	if canRaycast:
		if raycast.is_colliding():
			var collider = raycast.get_collider()
		
			# Check if the object is the shotgun (by name or group)
			if collider.name == "Shotgun" and not picked_up_shotgun:  
				pickup_text.visible = true
				can_pickup = true
				target_gun = collider
			
			elif collider.name == "youngGrandpa" and not killedGrandpa:
				if Input.is_action_just_pressed("Shoot") and canShoot:
					killedGrandpa = true
					canWalk = false
					canShoot = false
					objectiveTwo.label_settings.font_color = Color.GREEN
					shotgun_sound.play()
					muzzle_flash_light.visible = true
					muzzle_flash_animation.play("flash")
					muzzle_flash_model.play("fire")
					await time(0.11)
					blackScreen.visible = true
					await time(1.5)
					objectivesPanel.visible = false
					await time(0.5)
					FinalMonolog()
					
			elif collider.name == "LittleTimmy" and isBeatingNow == false:
				pickup_text.visible = true
				if Input.is_action_just_pressed("Interact"):
					BeatTimmy()
					
					
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
	objectiveOne.label_settings.font_color = Color.GREEN
	muzzle_flash_light.visible = true
	shotgun_prefab.visible = false
	shotgun.visible = true 
	pickup_text.visible = false
	can_pickup = false
	youngGrandpa.visible = true
	grampsCollider.disabled = false

func BeatTimmy():
	if fadeScren != null and fadeAnimation != null:
		objectiveOne.label_settings.font_color = Color.GREEN
		isBeatingNow = true
		pickup_text.visible = false
		fadeScren.visible = true
		objectivesPanel.visible = false
		fadeAnimation.play("fade")
		await fadeAnimation.animation_finished
		await time(2)
		get_tree().change_scene_to_file("res://Scenes/KickGrandchildAss.tscn")
		
func StartChase() -> void:
	print("grrgr")

			
func Jumpscare():
		walkSound.stop()
		canLook = false
		canWalk = false
		#chaseAmbience.stop()
		%Camera3D.rotation.x = 0
		animation_player.play("Jumpscare") 
		mrTime.position = Vector3(position.x + 2, mrTime.position.y, position.z)
		mrTime_anim.play("mixamo_com")
		mrTime_anim.seek(0.86)
		if not jumpscareSound.playing:
			jumpscareSound.play()
		await time(1)
		mrTime_anim.stop()
		jumpscareSound.stop()
		blackScreen.visible = true
		await time(0.7)
		monolog.visible = true
		await time(1.5)
		get_tree().change_scene_to_file("res://Scenes/OldNeighborhood.tscn")
		

func CheckDistance():
	if get_tree().current_scene.scene_file_path == "res://Scenes/OldNeighborhood.tscn":
		if not picked_up_shotgun:
			var distance = global_position.distance_to(shotgun_prefab.global_position)
			var raw_strength = clamp(1 - (distance / 70.0), 0.0, 2.0)
			var glitch_strength = (1 - pow(1 - raw_strength, 2.5))
			glitch_strength = min(glitch_strength, 0.45)

			# ---- NEW: Adjust based on player rotation (3D) ----
			var to_target = (shotgun_prefab.global_position - global_position).normalized()
			var to_target_2d = Vector2(to_target.x, to_target.z).normalized()
			var facing_dir = Vector2(-sin(rotation.y), -cos(rotation.y)).normalized()
			var angle_diff = facing_dir.angle_to(to_target_2d)
			var angle_factor = clamp(1.0 - (abs(angle_diff) / PI), 0.0, 1.0)
			glitch_strength *= angle_factor
			# ---------------------------------------------------

			var mat := mainShader.material
			if mat and mat is ShaderMaterial:
				mat.set_shader_parameter("_ScanLineJitter", glitch_strength)
				mat.set_shader_parameter("_ColorDrift", glitch_strength * 0.05)
				
		elif not killedGrandpa:
			var distance = global_position.distance_to(youngGrandpa.global_position)
			var raw_strength = clamp(1 - (distance / 70.0), 0.0, 2.0)
			var glitch_strength = (1 - pow(1 - raw_strength, 2.5))
			glitch_strength = min(glitch_strength, 0.45)

			# ---- NEW: Adjust based on player rotation (3D) ----
			var to_target = (youngGrandpa.global_position - global_position).normalized()
			var to_target_2d = Vector2(to_target.x, to_target.z).normalized()
			var facing_dir = Vector2(-sin(rotation.y), -cos(rotation.y)).normalized()
			var angle_diff = facing_dir.angle_to(to_target_2d)
			var angle_factor = clamp(1.0 - (abs(angle_diff) / PI), 0.0, 1.0)
			glitch_strength *= angle_factor
			# ---------------------------------------------------

			var mat := mainShader.material
			if mat and mat is ShaderMaterial:
				mat.set_shader_parameter("_ScanLineJitter", glitch_strength)
				mat.set_shader_parameter("_ColorDrift", glitch_strength * 0.05)

		
func _unhandled_input(event):
	if canLook:
		if event is InputEventMouseMotion:
			if isFreeMovement:
				yaw -= event.relative.x * mouseSensitivity
				
				rotation.y = yaw
				%Camera3D.rotate_x(-event.relative.y * mouseSensitivity)
				%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			
func time(seconds: float) -> void:
	if !is_inside_tree():
		await ready
	await get_tree().create_timer(seconds).timeout

func FinalMonolog():
	for i in len(monologLabels):
		monologLabels[i].visible = true
		await time(5)
		monologLabels[i].visible = false
		await time(0.3)
	get_tree().change_scene_to_file("res://Scenes/kickAssTransition.tscn")
	
