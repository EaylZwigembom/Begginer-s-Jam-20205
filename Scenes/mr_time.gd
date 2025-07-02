extends Area3D

@onready var moveAway = false

func _process(delta: float) -> void:
	if moveAway:
		global_translate(Vector3.RIGHT * -17 * delta)
		global_translate(Vector3.BACK * -10 * delta)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		moveAway = true
