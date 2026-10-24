extends Node2D


@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var trigger: Area2D = $Trigger
@onready var damage_zone: Area2D = $DamageZone

enum TrapState {
	HIDDEN,
	WARNING,
	EXTENDED,
	RETRACTING
}

var state = TrapState.HIDDEN

func activate_trap():
	state = TrapState.WARNING
	await get_tree().create_timer(0.3).timeout

	if not is_inside_tree():
		return

	state = TrapState.EXTENDED
	anim.play("rise")
	await anim.animation_finished
	for body in damage_zone.get_overlapping_bodies():
		if body is CharacterBody2D:
			body.dying = true

	if not is_inside_tree():
		return

	await get_tree().create_timer(1.5).timeout

	state = TrapState.RETRACTING
	anim.play_backwards("rise")
	await anim.animation_finished

	state = TrapState.HIDDEN


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass

func _on_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if state == TrapState.HIDDEN:
			activate_trap()


func _on_damage_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if state == TrapState.EXTENDED:
			body.dying = true
