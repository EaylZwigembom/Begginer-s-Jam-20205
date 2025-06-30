extends Node3D

@export var fade : ColorRect
@export var unFade : ColorRect
@export var screenFader : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await RenderingServer.frame_post_draw
	DisplayServer.window_set_title("The Unbirth", get_window().get_window_id())
	unFade.visible = true
	screenFader.play("unFade")
	await screenFader.animation_finished
	unFade.visible = false



func _on_start_game_pressed() -> void:
	fade.visible = true
	screenFader.play("fade")
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Scenes/GrandpaKickingAss.tscn")


func _on_quit_game_pressed() -> void:
	fade.visible = true
	screenFader.play("fade")
	await get_tree().create_timer(1.5).timeout
	get_tree().quit()
