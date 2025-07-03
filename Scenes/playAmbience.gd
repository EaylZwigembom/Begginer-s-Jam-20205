extends Node3D

@export var darkAmbience : AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	darkAmbience.play(Global.audio_position)
