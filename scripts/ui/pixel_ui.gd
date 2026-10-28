class_name UI
extends Object

const WHITE := Color.WHITE
const GOLD := Color(1.0, 0.84, 0.0)
const SOFT := Color(0.7, 0.7, 0.7)

static var _theme: Theme
static var font: Font
static var bold: Font

static func _sbt(path: String, margin: Vector4, pad: Vector4) -> StyleBoxTexture:
	var tex := load(path) as Texture2D
	var sbt := StyleBoxTexture.new()
	sbt.texture = tex
	sbt.texture_margin_left = margin.x
	sbt.texture_margin_top = margin.y
	sbt.texture_margin_right = margin.z
	sbt.texture_margin_bottom = margin.w
	sbt.content_margin_left = pad.x
	sbt.content_margin_top = pad.y
	sbt.content_margin_right = pad.z
	sbt.content_margin_bottom = pad.w
	return sbt

static func _button(t: Theme, type: String, color: String, size := 9, pad := Vector4(7, 3, 7, 7)) -> void:
	var tm := Vector4(4, 4, 4, 6)
	t.set_stylebox("normal", type, _sbt("res://art/ui2/btn_%s.png" % color, tm, pad))
	t.set_stylebox("hover", type, _sbt("res://art/ui2/btn_%s.png" % color, tm, pad))
	t.set_stylebox("pressed", type, _sbt("res://art/ui2/btn_%s_pressed.png" % color, tm, pad + Vector4(0, 3, 0, -3)))
	t.set_stylebox("hover_pressed", type, _sbt("res://art/ui2/btn_%s_pressed.png" % color, tm, pad + Vector4(0, 3, 0, -3)))
	t.set_stylebox("disabled", type, _sbt("res://art/ui2/btn_gray.png", tm, pad))
	t.set_stylebox("focus", type, StyleBoxEmpty.new())
	t.set_font("font", type, bold)
	t.set_font_size("font_size", type, size)
	for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color", "font_hover_pressed_color"]:
		t.set_color(c, type, WHITE)
	t.set_color("font_disabled_color", type, Color(1, 1, 1, 0.6))
	t.set_constant("h_separation", type, 3)

static func theme() -> Theme:
	if _theme:
		return _theme
	font = load("res://art/ui/pixel_font.fnt")
	bold = load("res://art/ui2/pixel_bold.fnt")
	var t := Theme.new()
	t.default_font = font
	t.default_font_size = 8
	t.set_color("font_color", "Label", WHITE)
	t.set_color("font_shadow_color", "Label", Color(0, 0, 0, 0.55))
	t.set_constant("shadow_offset_x", "Label", 1)
	t.set_constant("shadow_offset_y", "Label", 1)
	
	for v in [["Title", bold, 27, GOLD], ["Big", bold, 18, WHITE], ["Bold", bold, 9, WHITE], ["Small", font, 8, SOFT]]:
		t.set_type_variation(v[0], "Label")
		t.set_font("font", v[0], v[1])
		t.set_font_size("font_size", v[0], v[2])
		t.set_color("font_color", v[0], v[3])
		
	_button(t, "Button", "orange")
	for v in [["GreenButton", "green"], ["BlueButton", "blue"], ["RedButton", "red"], ["PurpleButton", "purple"], ["GrayButton", "gray"]]:
		t.set_type_variation(v[0], "Button")
		_button(t, v[0], v[1])
		
	t.set_type_variation("BigGreen", "Button")
	_button(t, "BigGreen", "green", 18, Vector4(14, 5, 14, 9))
	
	t.set_stylebox("panel", "PanelContainer", _sbt("res://art/ui2/panel.png", Vector4(5, 5, 5, 5), Vector4(8, 7, 8, 8)))
	for v in [["Card", "card"], ["GoldCard", "card_gold"], ["Pill", "pill"]]:
		t.set_type_variation(v[0], "PanelContainer")
		var pad_val := Vector4(4, 3, 5, 4) if v[0] == "Pill" else Vector4(6, 6, 6, 6)
		t.set_stylebox("panel", v[0], _sbt("res://art/ui2/%s.png" % v[1], Vector4(5, 5, 5, 5), pad_val))
		
	t.set_stylebox("background", "ProgressBar", _sbt("res://art/ui2/bar_bg.png", Vector4(2, 2, 2, 2), Vector4(1, 1, 1, 1)))
	t.set_stylebox("fill", "ProgressBar", _sbt("res://art/ui2/bar_fill.png", Vector4(1, 2, 1, 2), Vector4(0, 0, 0, 0)))
	
	_theme = t
	return t
static func button(text: String, callback: Callable, variation := "") -> Button:
	var b := Button.new()
	b.text = text
	if variation != "":
		b.theme_type_variation = variation
	if callback.is_valid():
		b.pressed.connect(callback)
	return b

static func icon_button(icon_name: String, callback: Callable, variation := "BlueButton") -> Button:
	var b := button("", callback, variation)
	b.icon = load("res://art/ui2/i_%s.png" % icon_name)
	return b

static func label(text: String, variation := "", align := HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var l := Label.new()
	l.text = text
	l.horizontal_alignment = align
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if variation != "":
		l.theme_type_variation = variation
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l

static func pic(path: String, scale := 1) -> TextureRect:
	var r := TextureRect.new()
	r.texture = load(path)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if r.texture:
		r.custom_minimum_size = r.texture.get_size() * scale
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r

static func icon(icon_name: String, scale := 1) -> TextureRect:
	return pic("res://art/ui2/i_%s.png" % icon_name, scale)

static func panel(variation := "") -> PanelContainer:
	var p := PanelContainer.new()
	if variation != "":
		p.theme_type_variation = variation
	return p

static func vbox(sep := 4) -> VBoxContainer:
	var b := VBoxContainer.new()
	b.add_theme_constant_override("separation", sep)
	return b

static func hbox(sep := 4) -> HBoxContainer:
	var b := HBoxContainer.new()
	b.add_theme_constant_override("separation", sep)
	return b

static func spacer() -> Control:
	var c := Control.new()
	c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c

## A dark pill with an icon and a number. The Label is in meta "label".
static func pill(icon_name: String, text: String) -> PanelContainer:
	var p := panel("Pill")
	var h := hbox(3)
	p.add_child(h)
	h.add_child(icon(icon_name))
	var l := label(text, "Bold")
	h.add_child(l)
	p.set_meta("label", l)
	return p

static func pop_in(c: Control, delay := 0.0) -> void:
	c.pivot_offset = c.size / 2.0
	c.resized.connect(func(): c.pivot_offset = c.size / 2.0)
	c.scale = Vector2(0.5, 0.5)
	c.modulate.a = 0.0
	var tw := c.create_tween().set_parallel(true)
	tw.tween_property(c, "scale", Vector2.ONE, 0.35).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(c, "modulate:a", 1.0, 0.15).set_delay(delay)

static func punch(c: Control, amount := 1.3) -> void:
	c.pivot_offset = c.size / 2.0
	var tw := c.create_tween()
	tw.tween_property(c, "scale", Vector2(amount, amount), 0.06)
	tw.tween_property(c, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
