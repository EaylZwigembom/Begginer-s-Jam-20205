extends Camera3D

@onready var originCam = %Camera3D

func _process(delta: float) ->void:
	transform = originCam.transform
