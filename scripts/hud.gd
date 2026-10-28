extends CanvasLayer


func _ready() -> void:
	%GameOverPanel.hide()
	%PausePanel.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not %GameOverPanel.visible:
		_on_pause_button_pressed()

func update_height(meters: int) -> void:
	%HeightLabel.text = "%dM" % meters

func update_coins(amount: int) -> void:
	%CoinLabel.text = str(amount)

func show_game_over(meters: int, coins: int, new_best: bool) -> void:
	%FinalHeight.text = "HEIGHT: %dM" % meters
	%BestLabel.text = "NEW BEST!" if new_best else "BEST: %dM" % Global.best_height
	%RunCoins.text = "COINS: +%d" % coins
	%GameOverPanel.show()

func _on_pause_button_pressed() -> void:
	if get_tree().paused:
		_on_resume_button_pressed()
		return
	Global.play_sfx("click")
	get_tree().paused = true
	%PausePanel.show()

func _on_resume_button_pressed() -> void:
	Global.play_sfx("click")
	get_tree().paused = false
	%PausePanel.hide()

func _on_retry_button_pressed() -> void:
	Global.play_sfx("click")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_button_pressed() -> void:
	Global.play_sfx("click")
	get_tree().paused = false
	Transition.change_scene("res://scenes/main_menu.tscn")
