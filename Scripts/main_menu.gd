extends Node3D

@export var clickSound : AudioStreamPlayer2D
@export var hoverSound : AudioStreamPlayer2D
@export var fade : ColorRect
@export var unFade : ColorRect
@export var screenFader : AnimationPlayer
@export var blackScreen : ColorRect
@export var warning : TextureRect
@export var warningAnim : AnimationPlayer
@export var mainMenuAmbience : AudioStreamPlayer2D
@export var SettingsPage : Control
@export var MainPage : Control

@export var volumeSlider : HSlider
var volumeValue
var sliderValue

@export var qualityDropdown : OptionButton
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await RenderingServer.frame_post_draw
	DisplayServer.window_set_title("The Unbirth", get_window().get_window_id())
	set_high_quality()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	unFade.visible = true
	screenFader.play("unFade")
	await screenFader.animation_finished
	unFade.visible = false
	mainMenuAmbience.play()
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
	MainPage.visible = true
	SettingsPage.visible = false
	
	var theme = Theme.new()

	var font = load("res://Assets/Fonts/fake receipt.otf") # Your retro .tres font
	theme.set_font("font", "OptionButton", font)
	
	theme.set_color("font_color", "OptionButton", Color.WHITE)
	theme.set_color("font_hover_color", "OptionButton", Color.YELLOW)
	
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0, 0, 0)
	theme.set_stylebox("normal", "OptionButton", stylebox)
	theme.set_stylebox("hover", "OptionButton", stylebox)

	qualityDropdown.theme = theme


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


func _on_save_settings_pressed() -> void:
	clickSound.play()
	MainPage.visible = true
	SettingsPage.visible = false


func _on_settings_pressed() -> void:
	clickSound.play()
	MainPage.visible = false
	SettingsPage.visible = true
	volumeValue = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	volumeSlider.value = db_to_linear(volumeValue)  # Slider uses linear [0.0 to 1.0]
	
	var msaa = ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_3d")
	var ssao = ProjectSettings.get_setting("rendering/environment/ssao_enabled")
	if msaa == 0 and not ssao:
		qualityDropdown.select(0)  # Low
	elif msaa == 2 and ssao:
		qualityDropdown.select(1)  # Medium
	elif msaa >= 4 and ssao:
		qualityDropdown.select(2)  # High
	else:
		qualityDropdown.select(1)  # Fallback to Medium


func _on_h_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
	sliderValue = value
	

func set_low_quality():
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 0)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", false)
	ProjectSettings.set_setting("rendering/environment/ssao_enabled", false)
	ProjectSettings.set_setting("rendering/environment/ssil_enabled", false)
	ProjectSettings.set_setting("rendering/reflections/high_quality_ggx", false)

func set_medium_quality():
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 2)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", true)
	ProjectSettings.set_setting("rendering/environment/ssao_enabled", true)
	ProjectSettings.set_setting("rendering/reflections/high_quality_ggx", true)

func set_high_quality():
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 4)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", true)
	ProjectSettings.set_setting("rendering/environment/ssao_enabled", true)
	ProjectSettings.set_setting("rendering/reflections/high_quality_ggx", true)



func _on_quallity_dropdown_item_selected(index: int) -> void:
	match index:
		0:
			set_low_quality()
		1:
			set_medium_quality()
		2:
			set_high_quality()
