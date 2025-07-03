extends Node3D

@export var talkLabel : Label
@export var talkControl : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(4).timeout
	talkControl.visible = true
	talkLabel.text = "I CAN'T BELIEVE HE KICKED ME OUT OF THE HOUSE!"
	await get_tree().create_timer(4).timeout
	talkLabel.text = "I HATE HIM SO MUCH!"
	await get_tree().create_timer(4).timeout
	talkControl.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
