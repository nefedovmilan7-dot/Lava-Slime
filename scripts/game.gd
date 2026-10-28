extends Node2D

const PIXELS_PER_METER := 16.0

@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $GameCamera
@onready var hud: CanvasLayer = $HUD

var start_y := 0.0
var height := 0 
var run_coins := 0
var game_over := false

func _ready() -> void:
	start_y = player.position.y
	player.died.connect(_on_player_died)
	player.coin_collected.connect(_on_coin_collected)
	hud.update_height(0)
	hud.update_coins(0)

func _process(_delta: float) -> void:
	if game_over:
		return
	var meters := int((start_y - player.position.y) / PIXELS_PER_METER)
	if meters > height:
		height = meters
		hud.update_height(height)

func _on_coin_collected() -> void:
	run_coins += 1
	Global.coins += 1
	hud.update_coins(run_coins)

func _on_player_died() -> void:
	game_over = true
	camera.shake(6.0)
	var new_best := Global.submit_height(height)
	Global.save_game()
	await get_tree().create_timer(1.2).timeout
	hud.show_game_over(height, run_coins, new_best)
