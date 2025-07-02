extends Node3D

@export var clickSound : AudioStreamPlayer2D
@export var hoverSound : AudioStreamPlayer2D
@export var fade : ColorRect
@export var unFade : ColorRect
@export var screenFader : AnimationPlayer
@export var blackScreen : ColorRect
@export var warning : TextureRect
@export var warningAnim : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await RenderingServer.frame_post_draw
	DisplayServer.window_set_title("The Unbirth", get_window().get_window_id())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	unFade.visible = true
	screenFader.play("unFade")
	await screenFader.animation_finished
	unFade.visible = false
	await get_tree().create_timer(1.5).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	blackScreen.visible = true
	warningAnim.play("unFade")
	await warningAnim.animation_finished
	blackScreen.visible = false
	await get_tree().create_timer(5).timeout
	warningAnim.play("fade")
	await warningAnim.animation_finished
	warning.visible = false


func _on_start_game_pressed() -> void:
	clickSound.play()
	fade.visible = true
	screenFader.play("fade")
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Scenes/GrandpaKickingAss.tscn")


func _on_quit_game_pressed() -> void:
	clickSound.play()
	fade.visible = true
	screenFader.play("fade")
	await get_tree().create_timer(1.5).timeout
	get_tree().quit()


func _on_start_game_mouse_entered() -> void:
	hoverSound.play()

func _on_quit_game_mouse_entered() -> void:
	hoverSound.play()
