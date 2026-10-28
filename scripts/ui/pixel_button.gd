class_name PixelButton
extends Button

func _ready() -> void:
	focus_mode = Control.FOCUS_NONE
	pivot_offset = size / 2.0
	resized.connect(func(): pivot_offset = size / 2.0)
	button_down.connect(_squash)
	pressed.connect(func():
		Global.play_sfx("click")
		Global.vibrate(12)
	)

func _squash() -> void:
	var tw := create_tween()
	tw.tween_property(self, "scale", Vector2(1.08, 0.9), 0.05)
	tw.tween_property(self, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
