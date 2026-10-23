
extends Area2D

@onready var body: Polygon2D = $Body
@onready var collision: CollisionShape2D = $CollisionShape2D

var wave_height = 8
var wave_width = 8
var wave_speed = 2
var wave_frequency = 0.05

func make_water_polygon() -> PackedVector2Array:
	var points := PackedVector2Array()
	var x := 0.0

	while x < water_length:
		var y = sin(x * wave_frequency) * wave_height
		var next_x = min(x + wave_width, water_length)

		points.append(Vector2(x, y))
		points.append(Vector2(next_x, y))

		x = next_x

	points.append(Vector2(water_length, water_height))
	points.append(Vector2(0, water_height))

	return points


var water_length = 200.0
var water_height = 100.0

func _ready() -> void:
	body.polygon = PackedVector2Array([
	Vector2.ZERO,
	Vector2(water_length, 0),
	Vector2(water_length,water_height),
	Vector2(0, water_height)
])
	$Wave.play()
	for i in range(1, 6):
		var tile = $Wave.duplicate()
		add_child(tile)
		tile.play()
		tile.position.x = i * 36
	var rect := RectangleShape2D.new()
	rect.size = Vector2(water_length,water_height)
	collision.shape = rect
	collision.position = Vector2(water_length,water_height) / 2
