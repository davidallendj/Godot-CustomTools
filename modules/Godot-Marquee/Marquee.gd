extends Control

@onready var label_message 	:= $Message
@onready var start: Control = $Start
@onready var end: Control 	= $End

func _ready() -> void:
	start_marquee()


func start_marquee(duration: float = 10.0) -> void:
	# set initial state of message before animating
	var fade_time: float = 1.0
	label_message.set_modulate(Color.TRANSPARENT)
	label_message.set_position(start.get_position())
	
	# fade in message while simultaneously slide to the right
	var tween := get_tree().create_tween()
	tween.parallel().tween_property(label_message, "modulate", Color.WHITE, fade_time)
	tween.parallel().tween_property(label_message, "position", end.get_position(), duration)
	
	# fade out message and repeat when done with callback
	tween.tween_property(label_message, "modulate", Color.TRANSPARENT, fade_time)
	tween.tween_callback(start_marquee.bind(duration))
