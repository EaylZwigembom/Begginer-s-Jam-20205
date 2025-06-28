class_name kid
extends Node3D

@onready var anim = $Model_And_Animations/AnimationPlayer
@export var grandpa : gramps
@onready var isDead
@onready var isAnimationStarted
@onready var isCalled = false;
# Called when the node enters the scene tree for the first time.

func ChildAnim() -> void:
	if anim:
		if isAnimationStarted:
			while !isDead:
				anim.play("Taking A Punch")
	if isDead:
		anim.play("Death")
	else:
		push_error("child_anim is null!")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	isDead = grandpa.isKidDead
	isAnimationStarted = grandpa.isBeatingStarted
	if isAnimationStarted and !isCalled:
		ChildAnim()
		isCalled = true
