extends Area2D

var taken := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if taken or not body.has_method("collect_coin"):
		return
	taken = true
	body.collect_coin()
	Global.play_sfx("coin", randf_range(0.95, 1.1))
	
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 10.0, 0.25)
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	tween.chain().tween_callback(queue_free)
