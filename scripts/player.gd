extends CharacterBody2D


signal died
signal coin_collected

const SPEED := 95.0
const ACCEL_GROUND := 900.0
const ACCEL_AIR := 650.0
const GRAVITY := 900.0
const JUMP_VELOCITY := -330.0
const MAX_FALL_SPEED := 420.0
const COYOTE_TIME := 0.1
const JUMP_BUFFER := 0.12

var dead := false
var coyote := 0.0
var buffer := 0.0
var was_on_floor := true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.sprite_frames = Global.skin_frames()
	sprite.play("idle")
	sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if dead:
		return
		
	if not is_on_floor():
		velocity.y = minf(velocity.y + GRAVITY * delta, MAX_FALL_SPEED)
		
	if is_on_floor():
		coyote = COYOTE_TIME
	else:
		coyote -= delta
		
	if Input.is_action_just_pressed("jump"):
		buffer = JUMP_BUFFER
	else:
		buffer -= delta
		
	if buffer > 0.0 and coyote > 0.0:
		velocity.y = JUMP_VELOCITY
		buffer = 0.0
		coyote = 0.0
		sprite.play("jump")
		Global.play_sfx("jump", randf_range(0.95, 1.05))
		
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.45
		
	var direction := Input.get_axis("move_left", "move_right")
	var accel := ACCEL_GROUND if is_on_floor() else ACCEL_AIR
	velocity.x = move_toward(velocity.x, direction * SPEED, accel * delta)
	
	if direction != 0.0:
		sprite.flip_h = direction < 0.0
		
	move_and_slide()
	_animate()

func _animate() -> void:
	var on_floor := is_on_floor()
	if on_floor and not was_on_floor:
		sprite.play("land")
		Global.play_sfx("land")
	was_on_floor = on_floor
	
	if not on_floor:
		if velocity.y > 20.0 and sprite.animation != "fall":
			sprite.play("fall")
	elif sprite.animation != "land" and sprite.animation != "idle":
		sprite.play("idle")

func _on_animation_finished() -> void:
	if sprite.animation == "land":
		sprite.play("idle")

func collect_coin() -> void:
	coin_collected.emit()

func die() -> void:
	if dead:
		return
	dead = true
	velocity = Vector2.ZERO
	sprite.play("die")
	Global.play_sfx("die")
	died.emit()
