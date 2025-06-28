class_name showMrTime
extends Area3D

@export var mrTime : Node3D
@export var playerScript : PlayerScript
@onready var playerEntered = false

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player" and playerEntered == false:
		mrTime.visible = true
		playerScript.startChase = true
		playerEntered = true
