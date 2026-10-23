extends CharacterBody2D

var jump_velocity = -250.0
var speed = 130
var jump_starting = false
var landing = false
var jump_pending = false

var coyote_timer = 0
const COYOTE_TIME = 0.12

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var was_on_floor = is_on_floor()

	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer = max(coyote_timer - delta, 0.0)
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer > 0):
		jump_pending = true
		jump_starting = true
		landing = false
		anim.play("jump_start")

	var direction := Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * speed
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

    # Landing
	if not was_on_floor and is_on_floor():
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
	if anim.animation == "jump_start" and jump_pending == true and anim.frame == 1:
		velocity.y = jump_velocity
		jump_pending = false
