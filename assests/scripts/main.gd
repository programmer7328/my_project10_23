extends Node2D

@onready var rain_timer: Timer = $RainTimer
var rain_scene = preload("res://assests/scenes/rain_drop.tscn")

# func _on_rain_timer_timeout() -> void:



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(rain_timer.time_left)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_rain_timer_timeout() -> void:
	var rain = rain_scene.instantiate()
	add_child(rain)

	rain.position = Vector2(
		randf_range(-930, 1292),
		randf_range(-1000, 300)
	)
