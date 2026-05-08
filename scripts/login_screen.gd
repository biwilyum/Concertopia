extends Control
# Legacy login screen — wired to AuthManager for compatibility.
# username_input is treated as the email field.

@onready var username_input: LineEdit = $username_input
@onready var password_input: LineEdit = $password_input
@onready var login_button: Button     = $Button
var error_label: Label = null

const HOME_SCENE  := "res://screens/home.tscn"
const LOGIN_SCENE := "res://screens/login.tscn"

func _ready() -> void:
	username_input.placeholder_text = "Email"
	password_input.placeholder_text = "Password"
	password_input.secret = true

	login_button.pressed.connect(_on_login_pressed)
	username_input.text_submitted.connect(func(_t): password_input.grab_focus())
	password_input.text_submitted.connect(func(_t): _attempt_login())

	AuthManager.login_success.connect(_on_login_success)
	AuthManager.login_failed.connect(_on_login_failed)

	_ensure_error_label()

func _ensure_error_label() -> void:
	error_label = Label.new()
	error_label.name = "ErrorLabel"
	error_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	error_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	error_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	error_label.position = Vector2(
		login_button.position.x,
		login_button.position.y + login_button.size.y + 8
	)
	error_label.size    = Vector2(login_button.size.x, 40)
	error_label.visible = false
	add_child(error_label)

func _on_login_pressed() -> void:
	_attempt_login()

func _attempt_login() -> void:
	var email    := username_input.text.strip_edges()
	var password := password_input.text
	if email.is_empty() or password.is_empty():
		_show_error("Please enter your email and password.")
		return
	_show_error("")
	login_button.disabled = true
	login_button.text = "Logging in..."
	AuthManager.login(email, password)

func _on_login_success(_user: Dictionary) -> void:
	login_button.disabled = false
	login_button.text = "Login"
	get_tree().change_scene_to_file(HOME_SCENE)

func _on_login_failed(reason: String) -> void:
	login_button.disabled = false
	login_button.text = "Login"
	_show_error(reason)

func _show_error(message: String) -> void:
	if error_label == null:
		return
	error_label.text    = message
	error_label.visible = not message.is_empty()
