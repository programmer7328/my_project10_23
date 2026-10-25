extends Area2D

var speed = 300.0

func _process(delta: float) -> void:
	position.y += speed * delta

	if position.y > 1000:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("water"):
		queue_free()
