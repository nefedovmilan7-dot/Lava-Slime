extends CanvasLayer

var curtain: Control
var busy := false
var _t := 0.0
var surface: TextureRect
var _atlas: AtlasTexture

func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	curtain = Control.new()
	curtain.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(curtain)
	
	var body := ColorRect.new()
	body.color = Color("b8221e")
	body.position = Vector2(-8, 11)
	body.size = Vector2(196, 1000)
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	curtain.add_child(body)
	
	_atlas = AtlasTexture.new()
	_atlas.atlas = load("res://art/world/lava.png")
	_atlas.region = Rect2(0, 0, 32, 12)
	
	surface = TextureRect.new()
	surface.texture = _atlas
	surface.stretch_mode = TextureRect.STRETCH_TILE
	surface.position = Vector2(-8, 0)
	surface.size = Vector2(196, 12)
	surface.mouse_filter = Control.MOUSE_FILTER_IGNORE
	curtain.add_child(surface)
	
	curtain.visible = false

func _process(delta: float) -> void:
	_t += delta
	_atlas.region = Rect2(0, (int(_t * 8.0) % 4) * 12, 32, 12)

func _height() -> float:
	return get_viewport().get_visible_rect().size.y

func change_scene(path: String) -> void:
	if busy:
		return
	busy = true
	curtain.visible = true
	curtain.position.y = _height() + 4
	Global.play_sfx("whoosh")
	
	var tw := create_tween()
	tw.tween_property(curtain, "position:y", -12.0, 0.32).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tw.finished
	
	get_tree().paused = false
	get_tree().change_scene_to_file(path)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var tw2 := create_tween()
	tw2.tween_property(curtain, "position:y", -_height() - 1020.0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tw2.finished
	
	curtain.visible = false
	busy = false
