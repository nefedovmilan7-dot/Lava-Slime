extends PanelContainer

signal changed

var id := ""

func setup(accessory_id: String) -> void:
	id = accessory_id
	%Preview.texture = load("res://art/slime/icon_%s.png" % id)
	%NameLabel.text = Global.ACCESSORIES[id][0]

func refresh() -> void:
	var button: Button = %ActionButton
	if Global.equipped == id:
		button.text = "WORN"
		button.icon = null
		button.disabled = true
	elif id in Global.owned:
		button.text = "WEAR"
		button.icon = null
		button.disabled = false
	else:
		button.text = str(Global.price_of(id))
		button.icon = preload("res://art/ui/coin_icon.png")
		button.disabled = Global.coins < Global.price_of(id)

func _on_action_button_pressed() -> void:
	if id in Global.owned:
		Global.equip(id)
		Global.play_sfx("click")
	else:
		Global.buy(id)
	changed.emit()
