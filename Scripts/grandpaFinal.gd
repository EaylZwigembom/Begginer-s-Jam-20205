class_name grampsFinal
extends Node3D

@export var anim : AnimationPlayer
@export var isBeatingStarted : bool
@export var isKidDead : bool
@export var blackScreen : ColorRect
@export var labels : Array[Label]
@export var fade : ColorRect
@export var unFade : AnimationPlayer
@export var talkLabel : Label
@export var talkControl : Control
#@export var darkAmbience : AudioEffect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	unFade.play("unFade")
	isBeatingStarted = false
	isKidDead = false
	GrampsPunch()


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
	unFade.play("fade")
	await unFade.animation_finished
	#monolog sequence
	for i in len(labels):
		labels[i].visible = true
		await get_tree().create_timer(5).timeout
		labels[i].visible = false
		await get_tree().create_timer(0.3).timeout
		
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Scenes/endItAll.tscn")
