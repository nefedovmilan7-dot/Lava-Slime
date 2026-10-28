@tool
extends StaticBody2D

## A sandy platform: it shakes when you land on it, then falls away.
@export var width := 40.0:
	set(value):
		width = value
		if is_node_ready():
			_apply_width()

var triggered := false

func _ready() -> void:
	_apply_width()
	if not Engine.is_editor_hint():
		$Detector.body_entered.connect(_on_detector_body_entered)

func _apply_width() -> void:
	$Look.size = Vector2(width, 8)
	$Look.position = Vector2(-width / 2.0, 0)
	
	var shape := RectangleShape2D.new()
	shape.size = Vector2(width, 6)
	$CollisionShape2D.shape = shape
	$CollisionShape2D.position = Vector2(0, 3)
	
	var sensor := RectangleShape2D.new()
	sensor.size = Vector2(width - 4, 4)
	$Detector/CollisionShape2D.shape = sensor
	$Detector/CollisionShape2D.position = Vector2(0, -2)

func _on_detector_body_entered(body: Node2D) -> void:
	if triggered or not body is CharacterBody2D:
		return
	if body.velocity.y < 0.0:
		return
		
	triggered = true
	Global.play_sfx("crumble")
	
	var tween := create_tween()
	for i in 6:
		tween.tween_property($Look, "position:x", -width / 2.0 + (2 if i % 2 == 0 else -2), 0.06)
	tween.tween_callback(_fall)

func _fall() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", position.y + 60.0, 0.6).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, 0.6)
	tween.chain().tween_callback(queue_free)
