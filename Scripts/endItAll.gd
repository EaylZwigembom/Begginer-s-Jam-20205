extends Camera3D

@export var car_animation : AnimationPlayer
@export var instruction : Label
@export var unFade: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	unFade.play("unFade")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		instruction.visible = false
		car_animation.play("end")
		await car_animation.animation_finished
		get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
		
