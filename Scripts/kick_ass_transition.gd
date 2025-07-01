extends Node3D

@export var fadeScreen : ColorRect
@export var fadeAnimation : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fadeAnimation.play("unFade")
	await fadeAnimation.animation_finished
