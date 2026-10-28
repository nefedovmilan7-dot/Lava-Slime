extends Node2D

const PLATFORM := preload("res://scenes/platform.tscn")
const MOVING := preload("res://scenes/moving_platform.tscn")
const CRUMBLE := preload("res://scenes/crumble_platform.tscn")
const SPIKES := preload("res://scenes/spikes.tscn")
const COIN := preload("res://scenes/coin.tscn")
const ROCK := preload("res://scenes/rock.tscn")

const LEFT := 16.0 
const RIGHT := 164.0 
const PIXELS_PER_METER := 16.0

@export var camera: Camera2D
@export var lava: Node2D
@export var start_y := 300.0 

var next_y := 0.0
var last_x := 90.0
var rock_timer := 4.0

func _ready() -> void:
	next_y = start_y

func _process(delta: float) -> void:
	while next_y > camera.top_edge() - 320.0:
		_spawn_row()
	_remove_old_stuff()
	_falling_rocks(delta)

func meters_at(y: float) -> float:
	return (start_y - y) / PIXELS_PER_METER

func difficulty_at(y: float) -> float:
	return clampf(meters_at(y) / 250.0, 0.0, 1.0)

func _spawn_row() -> void:
	var d := difficulty_at(next_y)
	var m := meters_at(next_y)
	
	next_y -= randf_range(lerpf(30.0, 40.0, d), lerpf(42.0, 54.0, d))
	
	var width := snappedf(randf_range(lerpf(48.0, 28.0, d), lerpf(72.0, 44.0, d)), 8.0)
	
	var step := lerpf(60.0, 80.0, d)
	var x := clampf(last_x + randf_range(-step, step), LEFT + width / 2.0 + 2.0, RIGHT - width / 2.0 - 2.0)
	last_x = x
	
	# 4. which kind
	var roll := randf()
	var moving_chance := lerpf(0.15, 0.4, d) if m > 40.0 else 0.0
	var crumble_chance := lerpf(0.1, 0.3, d) if m > 90.0 else 0.0
	
	var p: Node2D
	var spikes_x := 0.0
	var has_spikes := false
	
	if roll < moving_chance:
		p = MOVING.instantiate()
		p.width = width
		p.position = Vector2(90.0, next_y)
		p.distance = minf(lerpf(30.0, 50.0, d), (RIGHT - LEFT - width) / 2.0 - 4.0)
		p.speed = lerpf(1.0, 2.2, d)
	elif roll < moving_chance + crumble_chance:
		p = CRUMBLE.instantiate()
		p.width = width
		p.position = Vector2(x, next_y)
	else:
		p = PLATFORM.instantiate()
		p.width = width
		p.position = Vector2(x, next_y)
		
	if m > 140.0 and width >= 40.0 and randf() < lerpf(0.2, 0.4, d):
		var spikes := SPIKES.instantiate()
		var side := 1.0 if randf() < 0.5 else -1.0
		spikes_x = side * (width / 2.0 - 8.0)
		has_spikes = true
		spikes.position = Vector2(spikes_x, 0.0)
		p.add_child(spikes)
		
	add_child(p)
	
	if randf() < 0.4:
		var coin := COIN.instantiate()
		coin.position = Vector2(0.0, -12.0)
		if has_spikes:
			coin.position.x = -spikes_x
		p.add_child(coin)

func _remove_old_stuff() -> void:
	for child in get_children():
		if child.position.y > lava.position.y + 80.0:
			child.queue_free()

func _falling_rocks(delta: float) -> void:
	if meters_at(camera.position.y) < 180.0:
		return
	rock_timer -= delta
	if rock_timer <= 0.0:
		rock_timer = randf_range(2.5, 5.0)
		var rock := ROCK.instantiate()
		rock.camera = camera
		rock.position = Vector2(randf_range(LEFT + 8.0, RIGHT - 8.0), camera.top_edge())
		add_child(rock)
