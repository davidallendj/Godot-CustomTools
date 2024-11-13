extends Control

signal button_pressed(index: int)

@export var hide_delay := 1.0				## Set the delay before hiding buttons.
@export var enable_sticky_buttons := true	## Pressed buttons without sliding motion.
@export var keep_visible := false			## Always show the other buttons.

var _lmb_pressed := false
var _button_index := -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set up callbacks for showing buttons dynamically
	$timer.timeout.connect(_toggle_view.bind(false))
	$action.button_down.connect(_toggle_view.bind(true))
	$action.button_up.connect($timer.start.bind(hide_delay))
	
	# set button index to correct region
	$action/up.mouse_entered.connect(_set_button_index.bind($action/up.get_index()))
	$action/right.mouse_entered.connect(_set_button_index.bind($action/right.get_index()))
	$action/down.mouse_entered.connect(_set_button_index.bind($action/down.get_index()))
	$action/left.mouse_entered.connect(_set_button_index.bind($action/left.get_index()))
	
	# set whether to show the buttons initially
	_toggle_view(keep_visible)


func _toggle_view(is_pressed: bool) -> void:
	if keep_visible:
		is_pressed = true
	$action/up.set_visible(is_pressed)
	$action/right.set_visible(is_pressed)
	$action/down.set_visible(is_pressed)
	$action/left.set_visible(is_pressed)

func _set_button_index(index: int) -> void:
	_button_index = index

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_lmb_pressed = event.get_button_index() == MOUSE_BUTTON_LEFT and event.is_pressed()
		
		# handle pressing the left mouse button
		if _lmb_pressed:
			$timer.stop()
		
		# handle releasing the left mouse button
		if event.get_button_index() == MOUSE_BUTTON_LEFT and event.is_released():
			print("button index: ", _button_index)
			button_pressed.emit(_button_index)
			const delta := 10
			match _button_index:
				0: $cursor.set_position($cursor.get_position() + Vector2(0, -1) * delta)
				1: $cursor.set_position($cursor.get_position() + Vector2(1, 0) * delta)
				2: $cursor.set_position($cursor.get_position() + Vector2(0, 1) * delta)
				3: $cursor.set_position($cursor.get_position() + Vector2(-1, 0) * delta)
			if not enable_sticky_buttons:
				_button_index = -1
			else:
				$timer.start(hide_delay)
	
	#if _lmb_pressed and event is InputEventMouseMotion:
		#$cursor.set_position(get_local_mouse_position())
