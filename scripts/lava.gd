extends Area2D


@export var camera: Camera2D
@export var start_delay := 2.0 
@export var start_speed := 10.0 
@export var acceleration := 0.45
@export var max_speed := 72.0
@export var catch_up_distance := 100.0

var speed := 0.0
var time := 0.0

@onready var surface: Sprite2D = $Surface

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	time += delta
	var frame := int(time * 6.0) % 4
	surface.region_rect.position = Vector2(fmod(time * 10.0, 32.0), frame * 12)
	
	if time < start_delay:
		return
		
	speed = minf(start_speed + acceleration * (time - start_delay), max_speed)
	var current := speed
	
	if camera and position.y > camera.bottom_edge() + catch_up_distance:
		current = maxf(speed, 160.0) 
		
	position.y -= current * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.die()
