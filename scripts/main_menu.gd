extends Control

func _ready() -> void:
	%Slime.sprite_frames = Global.skin_frames()
	%Slime.play("idle")
	%BestLabel.text = "BEST: %dM" % Global.best_height
	%CoinsLabel.text = "COINS: %d" % Global.coins

func _on_play_button_pressed() -> void:
	Global.play_sfx("click")
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_shop_button_pressed() -> void:
	Global.play_sfx("click")
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
