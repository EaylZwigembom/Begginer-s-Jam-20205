extends Node3D

#@export var kidMonolog : Array[AudioEffect]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	#kidMonolog[0].play()
	#await kidMonolog[0].finished
	#kidMonolog[1].play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
