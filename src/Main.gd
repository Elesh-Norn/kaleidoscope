extends Control

@onready var label = $RichTextLabel
@onready var canvas = $Canvas
var tween: Tween

func _ready():
	canvas.connect("update_text", on_text_update)
	
	
func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		canvas.increase_setting()
	elif Input.is_action_just_pressed("ui_down"):
		canvas.decrease_setting()
	elif Input.is_action_just_pressed("ui_left"):
		canvas.previous_setting()
	elif Input.is_action_just_pressed("ui_right"):
		canvas.next_setting()

func on_text_update(text):
	if tween:
		tween.kill()
	tween = create_tween()
	
	label.modulate = Color.WHITE_SMOKE
	label.text = text
	tween.tween_property(label, "modulate", Color.TRANSPARENT, 2)
	

