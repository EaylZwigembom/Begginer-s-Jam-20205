extends Node

@onready var grandpa_anim = get_node("Grandpa/Model_And_Animations/AnimationPlayer")
@onready var child_anim = get_node("Kid/Model_And_Animations/AnimationPlayer")
@onready var isKidDead = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GrampsPunch()
	ChildAnim()


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
	
