extends Control

const CARD := preload("res://scenes/shop_card.tscn")

func _ready() -> void:
	for id in Global.ACCESSORIES:
		var card := CARD.instantiate()
		%Grid.add_child(card)
		card.setup(id)
		card.changed.connect(_refresh)
	_refresh()

func _refresh() -> void:
	%CoinsLabel.text = str(Global.coins)
	for card in %Grid.get_children():
		card.refresh()

func _on_back_button_pressed() -> void:
	Global.play_sfx("click")
	Transition.change_scene("res://scenes/main_menu.tscn")
