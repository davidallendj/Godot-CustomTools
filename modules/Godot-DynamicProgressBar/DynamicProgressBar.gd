extends ProgressBar

@onready var subbar := $ProgressBar
@export var enable_colors: bool = true

@export var high_color := Color.GREEN
@export var medium_color := Color.YELLOW
@export var low_color := Color.RED

func _ready() -> void:
	set_bar_value(value, 0)
	set_bar_max(max_value)


func set_bar_value(_value: float, duration: float = 0.1) -> void:
	var percent: float = _value / get_max() * 100.0
	if enable_colors:
		var box := StyleBoxFlat.new()
		if percent < 50.0 and percent >= 25.0: 	box.set("bg_color", medium_color)
		elif percent < 25.0: 					box.set("bg_color", low_color)
		else:									box.set("bg_color", high_color)
		set("theme_override_styles/fill", box)
	#print(_value)
	var tween := get_tree().create_tween().set_parallel()
	tween.tween_property(self, "value", _value, duration)
	tween.tween_property(subbar, "value", _value, duration * 5.0)
	#super.set_value(_value)


func set_bar_max(_max_value: float) -> void:
	set_max(_max_value)
	subbar.set_max(_max_value)
