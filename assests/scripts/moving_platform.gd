extends AnimatableBody2D

@export var distance = 35
@export var speed = randf_range(1.8, 2.2)

var start_y: float
var time = 0

func _ready() -> void:
	start_y = position.y

func _physics_process(delta: float) -> void:
	time += delta
	position.y = start_y + sin(time * speed) * distance
