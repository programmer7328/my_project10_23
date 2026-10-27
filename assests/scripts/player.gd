extends CharacterBody2D

#---variables---

#player movements
var jump_velocity = -280
var speed = 150
var acceleration = 750
var friction = 850

#jump animaitions
var landing = false
var jump_pending = false
var jump_animation_pending = false
var jump_starting = false

#jump
var coyote_timer = 0
const COYOTE_TIME = 0.12
var jump_timer = 0
const JUMP_BUFFERING = 0.12

var dying = false
var winning = false
var title_screning = false
var fade_speed = 1

var coin = 0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var water: Area2D = $"../Water"
@onready var door: AnimatedSprite2D = $"../door"
@onready var re_label: Label = $"../RestartLabel"
@onready var control: Control = $"../Control"
@onready var coin_: Area2D = $"../Coin"

#camera things
var look_ahead_distance = 0
var camera_offset_x = 0
var camera_speed = 5

var player_position = Vector2(0,0)
var water_position = Vector2(0,0)



func _on_animation_finished() -> void:
	if anim.animation == "jump_start":
		jump_starting = false
	elif anim.animation == "jump_land":
		landing = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "jump_start":
		jump_starting = false

	elif anim.animation == "jump_land":
		landing = false

func _on_animated_sprite_2d_frame_changed() -> void:
	if anim.animation == "jump_start" and jump_animation_pending == true and anim.frame == 1:
		velocity.y = jump_velocity
		jump_animation_pending = false
		jump_pending = false

func restart():
	dying = false
	modulate.a = 1.0
	position = player_position
	water.position = water_position
	door.frame = 0
	winning = false
	re_label.visible = false
	control.time = 0
	coin = 0
	coin_.show()
	coin_.get_node("CollisionShape2D").set_deferred("disabled", false)





func _ready() -> void:
	re_label.visible = false
	player_position = position
	water_position = water.position
	door.frame = 0
	camera.zoom = Vector2(2, 2)
	camera.position.x = 50
	camera.position.y = -20
	title_screning = true


func _physics_process(delta: float) -> void:
	
	re_label.global_position = global_position + Vector2(-re_label.size.x / 2, 40)

	if dying:
		camera.position = Vector2.ZERO
		modulate.a = move_toward(modulate.a, 0, fade_speed * delta)
		anim.play("idle")
		anim.stop()
		anim.frame = 0
		re_label.visible = true
		if Input.is_action_just_pressed("restart"):
			restart()
		return

	if winning:
		camera.position.x = 90

	var was_on_floor = is_on_floor()

	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer = max(coyote_timer - delta, 0)
		velocity += get_gravity() * delta

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5

	if Input.is_action_just_pressed("jump") and not winning and not title_screning:
		jump_pending = true
		jump_timer = JUMP_BUFFERING
	if jump_timer > 0:
		jump_timer=max(jump_timer-delta,0)

	if jump_pending and jump_timer > 0 and(is_on_floor() or coyote_timer > 0) and not jump_starting:
		jump_pending = true
		jump_starting = true
		jump_animation_pending = true
		landing = false
		anim.play("jump_start")

	var direction := Input.get_axis("move_left", "move_right")

	if not winning and not title_screning:
		camera.zoom = Vector2(1, 1)
		camera.position = Vector2.ZERO
		if direction:
			var target_speed = direction * speed
			var rate = acceleration

			if velocity.x * direction < 0:
				rate = friction
			else:
				rate = acceleration * clamp(1.0 - abs(velocity.x) / speed, 0.35, 1.0)

			velocity.x = move_toward(velocity.x, target_speed, rate * delta)
			anim.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)

	else:
		velocity = Vector2.ZERO
		if not title_screning:
			re_label.visible = true
			if Input.is_action_just_pressed("restart"):
				restart()

	if title_screning and Input.is_action_just_pressed("jump"):
		title_screning = false
	

	move_and_slide()

	# Landing
	if not was_on_floor and is_on_floor() and not jump_animation_pending:
		jump_starting = false
		landing = true
		anim.play("jump_land")
		return

	# In the air
	if not is_on_floor():
		if jump_starting or landing:
			return

		if velocity.y < 0:
			anim.play("jump_up")
		else:
			anim.play("jump_down")
		return

	# On the ground
	if landing:
		return
	if jump_starting:
		return

	if abs(velocity.x) > 1:
		anim.play("run")
	else:
		anim.play("idle")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		door.play("default")
		await get_tree().create_timer(0.1).timeout
		winning = true
