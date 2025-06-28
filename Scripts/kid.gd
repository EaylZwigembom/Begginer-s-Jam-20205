class_name kid
extends Node3D

@onready var animation_player = $Model_And_Animations/AnimationPlayer
@export var grandpa : gramps
@onready var isKidDead
@onready var isAnimationStarted
@onready var isCalled = false;
@onready var isBeatingEnded = false;
# Called when the node enters the scene tree for the first time.

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	isKidDead = grandpa.isKidDead
	isAnimationStarted = grandpa.isBeatingStarted
	if !isBeatingEnded:
		if isAnimationStarted and !isCalled:
			if !isKidDead:
				GetPunched()
				isCalled = true
		elif isKidDead:
			isCalled = false
			if !isCalled:
				Death();
				isCalled = true
	else:
		print("Child Dead...")

func GetPunched():
	animation_player.play("getPunched")
	if animation_player.animation_finished:
		animation_player.play("getPunched", -1.0)
		if animation_player.animation_finished:
			isCalled = false
		
func Death():
	animation_player.play("Death")
	if animation_player.animation_finished:
		await get_tree().create_timer(3).timeout
		isBeatingEnded = true
