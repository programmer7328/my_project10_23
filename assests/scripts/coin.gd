extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.coin += 1
		hide()
		$CollisionShape2D.set_deferred("disabled", true)

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	anim.play("default")
