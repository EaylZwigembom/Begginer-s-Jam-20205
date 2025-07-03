class_name gramps
extends Node3D

@export var anim : AnimationPlayer
@export var isBeatingStarted : bool
@export var isKidDead : bool
@export var blackScreen : ColorRect
@export var labels : Array[Label]
@export var darkAmbience : AudioStreamPlayer2D
@export var talkLabel : Label
@export var talkControl : Control
#@export var darkAmbience : AudioEffect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	isBeatingStarted = false
	isKidDead = false
	blackScreen.visible = true
	darkAmbience.play()
	await get_tree().create_timer(1).timeout
	labels[0].visible = true
	await get_tree().create_timer(5).timeout
	labels[0].visible = false
	await get_tree().create_timer(0.3).timeout
	labels[1].visible = true
	await get_tree().create_timer(5).timeout
	labels[1].visible = false
	await get_tree().create_timer(0.3).timeout
	labels[2].visible = true
	await get_tree().create_timer(5).timeout
	labels[2].visible = false
	await get_tree().create_timer(0.5).timeout
	blackScreen.visible = false
	GrampsPunch()  # or a real animation name

func GrampsPunch() -> void:
	isBeatingStarted = true
	anim.play("Punching2")
	talkControl.visible = true
	talkLabel.text = "EAT SHIT LITTLE TIMMY!"
	await anim.animation_finished
	anim.play("Punching2")
	talkLabel.text = "I AM BIG OLD TIMMY AND I HATE YOU LITTLE TIMMY!"
	await anim.animation_finished
	isKidDead = true
	await get_tree().create_timer(0.5).timeout
	talkLabel.text = "I AM GOING TO KILL YOU NOW!!"
	anim.play("Special Move")
	await anim.animation_finished
	anim.play("Celebrating")
	talkLabel.text = "YEAH! WOOOH!!"
	await anim.animation_finished
	talkControl.visible = false
	blackScreen.visible = true
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/RoamNeighborhoodPresentTime.tscn")
