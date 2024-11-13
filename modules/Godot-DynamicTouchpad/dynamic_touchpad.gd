extends Control

signal button_pressed(index: int)


var _lmb_pressed := false
var _button_index := -1
var _enable_sticky_buttons := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$start.button_down.connect(_toggle_view.bind(true))
	$start.button_up.connect(_toggle_view.bind(false))
	
	# set button index to correct region
	$start/up.mouse_entered.connect(_set_button_index.bind($start/up.get_index()))
	$start/right.mouse_entered.connect(_set_button_index.bind($start/right.get_index()))
	$start/down.mouse_entered.connect(_set_button_index.bind($start/down.get_index()))
	$start/left.mouse_entered.connect(_set_button_index.bind($start/left.get_index()))


func _toggle_view(is_pressed: bool) -> void:
	$start/up.set_visible(is_pressed)
	$start/right.set_visible(is_pressed)
	$start/down.set_visible(is_pressed)
	$start/left.set_visible(is_pressed)

func _set_button_index(index: int) -> void:
	_button_index = index

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_lmb_pressed = event.get_button_index() == MOUSE_BUTTON_LEFT and event.is_pressed()
		if not _lmb_pressed:
			print("button index: ", _button_index)
			button_pressed.emit(_button_index)
			const delta := 10
			match _button_index:
				0: $cursor.set_position($cursor.get_position() + Vector2(0, -1) * delta)
				1: $cursor.set_position($cursor.get_position() + Vector2(1, 0) * delta)
				2: $cursor.set_position($cursor.get_position() + Vector2(0, 1) * delta)
				3: $cursor.set_position($cursor.get_position() + Vector2(-1, 0) * delta)
			if not _enable_sticky_buttons:
				_button_index = -1
	
	#if _lmb_pressed and event is InputEventMouseMotion:
		#$cursor.set_position(get_local_mouse_position())
