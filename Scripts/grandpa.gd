class_name gramps
extends Node3D

@export var anim : AnimationPlayer
@export var isBeatingStarted : bool
@export var isKidDead : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isBeatingStarted = false
	isKidDead = false
	if anim:
		GrampsPunch()  # or a real animation name
	else:
		push_error("grandpa_anim is null!")

func GrampsPunch() -> void:
	isBeatingStarted = true
	anim.play("Punching2")
	await anim.animation_finished
	anim.play("Punching2")
	await anim.animation_finished
	isKidDead = true
	await get_tree().create_timer(0.5).timeout
	anim.play("Special Move")
	await anim.animation_finished
	anim.play("Celebrating")
