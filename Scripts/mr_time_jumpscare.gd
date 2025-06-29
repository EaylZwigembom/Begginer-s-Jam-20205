class_name jumpscareTrigger
extends Area3D

@export var playerScript : PlayerScript
@onready var playerEntered = false

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player" and playerEntered == false:
		playerScript.jumpscare = true
		set_process_mode(Node.PROCESS_MODE_DISABLED)
		playerEntered = true
