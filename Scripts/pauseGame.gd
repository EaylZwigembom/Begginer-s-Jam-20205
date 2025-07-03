extends CanvasLayer

@export var pause_menu : CanvasLayer
@export var mainPage : Control
@export var settingsPage : Control
@export var hoverSound : AudioStreamPlayer2D
@export var clickSound : AudioStreamPlayer2D

@export var volumeSlider : HSlider
var volumeValue

@export var qualityDropdown : OptionButton
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	set_high_quality()
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("Escape"):  # Usually Escape
		if get_tree().paused:
			resume_game()
		else:
			pause_game()
			
func pause_game():
	get_tree().paused = true
	pause_menu.visible = true
	mainPage.visible = true
	settingsPage.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)  # Optional: show cursor

func resume_game():
	get_tree().paused = false
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Optional: hide cursor again


func _on_resume_game_pressed() -> void:
	resume_game()


func _on_settings_pressed() -> void:
	clickSound.play()
	mainPage.visible = false
	settingsPage.visible = true
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


func _on_go_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")


func _on_go_to_menu_mouse_entered() -> void:
	hoverSound.play()


func _on_exit_settings_pressed() -> void:
	clickSound.play()
	mainPage.visible = true
	settingsPage.visible = false




func _on_volume_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)


func _on_quallity_dropdown_item_selected(index: int) -> void:
	match index:
		0:
			set_low_quality()
		1:
			set_medium_quality()
		2:
			set_high_quality()
	
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
