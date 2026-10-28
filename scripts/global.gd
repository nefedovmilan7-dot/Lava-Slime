extends Node

const SAVE_PATH := "user://save.cfg"

const ACCESSORIES := {
	"none": ["NO HAT", 0],
	"party_hat": ["PARTY HAT", 15],
	"bow": ["RED BOW", 25],
	"shades": ["SHADES", 40],
	"top_hat": ["TOP HAT", 60],
	"viking": ["VIKING", 90],
	"crown": ["CROWN", 150],
}

const SFX := {
	"jump": preload("res://audio/jump.wav"),
	"land": preload("res://audio/land.wav"),
	"coin": preload("res://audio/coin.wav"),
	"die": preload("res://audio/die.wav"),
	"buy": preload("res://audio/buy.wav"),
	"click": preload("res://audio/click.wav"),
	"crumble": preload("res://audio/crumble.wav"),
	"rock": preload("res://audio/rock.wav"),
	"whoosh": preload("res://audio/whoosh.wav"),
}

var coins := 0
var best_height := 0
var owned: Array = ["none"]
var equipped := "none"
var music: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_game()
	_start_music()

func skin_frames(id: String = equipped) -> SpriteFrames:
	return load("res://art/slime/slime_%s.tres" % id)

func price_of(id: String) -> int:
	return ACCESSORIES[id][1]

func buy(id: String) -> bool:
	if id in owned:
		equip(id)
		return true
	if coins < price_of(id):
		return false
	coins -= price_of(id)
	owned.append(id)
	equipped = id
	save_game()
	play_sfx("buy")
	return true

func equip(id: String) -> void:
	if id in owned:
		equipped = id
		save_game()

func submit_height(meters: int) -> bool:
	if meters > best_height:
		best_height = meters
		return true
	return false

func save_game() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("player", "coins", coins)
	cfg.set_value("player", "best_height", best_height)
	cfg.set_value("player", "owned", owned)
	cfg.set_value("player", "equipped", equipped)
	cfg.save(SAVE_PATH)

func load_game() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	coins = cfg.get_value("player", "coins", 0)
	best_height = cfg.get_value("player", "best_height", 0)
	owned = cfg.get_value("player", "owned", ["none"])
	equipped = cfg.get_value("player", "equipped", "none")

func reset_save() -> void:
	coins = 0
	best_height = 0
	owned = ["none"]
	equipped = "none"
	save_game()

func play_sfx(sfx_name: String, pitch := 1.0) -> void:
	if not SFX.has(sfx_name):
		push_warning("SFX not found in Global: '%s'" % sfx_name)
		return
	var p := AudioStreamPlayer.new()
	p.stream = SFX[sfx_name]
	p.pitch_scale = pitch
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)

func vibrate(ms := 12) -> void:
	if OS.has_feature("mobile"):
		Input.vibrate_handheld(ms)

func _start_music() -> void:
	var stream: AudioStreamWAV = preload("res://audio/music.wav")
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_end = int(stream.get_length() * stream.mix_rate)
	music = AudioStreamPlayer.new()
	music.stream = stream
	music.volume_db = -20.0
	add_child(music)
	music.play()
