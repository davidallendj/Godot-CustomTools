extends Control

class_name Notification

signal finished()

@onready var label_title 	:= $MarginContainer/VBoxContainer/LabelTitle
@onready var label_message 	:= $MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/LabelMessage
@onready var image 			:= $MarginContainer/VBoxContainer/HBoxContainer/Image
@onready var button 		:= $Button
@onready var timer			:= $Timer


func _ready() -> void:
	slide_in()
	timer.timeout.connect(_slide_out)


func slide_in(duration: float = 1.0, delay: float = 3.0) -> void:
	var viewport_rect := get_viewport_rect()
	var initial := Vector2(
		viewport_rect.size.x / 4,
		viewport_rect.position.y + viewport_rect.size.y
	)
	set_position(initial)
	var final := Vector2(viewport_rect.size.x / 4, viewport_rect.position.y + viewport_rect.size.y / 1.5 )
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position", final, duration).set_ease(Tween.EASE_IN)
	tween.tween_callback(timer.start.bind(delay))


func _slide_out(duration: float = 1.0) -> void:
	var viewport_rect := get_viewport_rect()
	var final := Vector2(
		viewport_rect.size.x / 4 , 
		viewport_rect.position.y + viewport_rect.size.y + 300
	)
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position", final, duration).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func()->void:
		finished.emit()
		queue_free()
	)
