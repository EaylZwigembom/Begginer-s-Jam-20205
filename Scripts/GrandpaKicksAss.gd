extends Node

@export var grandpa_anim = null
@export var child_anim = null
@export var isKidDead = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if grandpa_anim:
		GrampsPunch()  # or a real animation name
	else:
		push_error("grandpa_anim is null!")

	if child_anim:
		ChildAnim()
	else:
		push_error("child_anim is null!")


func GrampsPunch() -> void:
	grandpa_anim.play("Punching")
	await grandpa_anim.animation_finished;
	isKidDead = true;
	await get_tree().create_timer(0.5).timeout
	grandpa_anim.play("Special Move")
	
func _on_punching_finished() -> bool:
	return true;
func ChildAnim() -> void:
	while !isKidDead:
		child_anim.play("Taking A Punch")
	if isKidDead:
		child_anim.play("Death")
	
