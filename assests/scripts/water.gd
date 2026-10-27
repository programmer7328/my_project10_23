
extends Area2D

@onready var body: Polygon2D = $Body
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var player: CharacterBody2D = $"../Player"

var water_length = 5000
var water_height = 1000
var water_speed = 17
var tile_count = ceili(water_length / 36.0)
var water_alpha = 0.6
var random_speed = 0

func _ready() -> void:
	$Body.modulate.a = water_alpha
	$Wave.modulate.a = water_alpha
	body.polygon = PackedVector2Array([
	Vector2(-water_length, 0),
	Vector2(36, 0),
	Vector2(36, water_height),
	Vector2(-water_length, water_height)
])
	$Wave.play()
	for i in range(1, tile_count):
		var tile = $Wave.duplicate()
		add_child(tile)
		tile.play()
		tile.position.x = -i * 36
		tile.modulate.a = water_alpha
	var rect := RectangleShape2D.new()
	rect.size = Vector2(water_length + 36, water_height)
	collision.shape = rect
	collision.position = Vector2((36 - water_length) / 2.0, water_height / 2.0 - 5)

func _physics_process(delta: float) -> void:
	if not player.title_screning:
		random_speed = randi_range(water_speed-(water_speed/1.5), water_speed+(water_speed/1.5))
		position.y -= water_speed * delta

func _on_body_entered(entered_body: Node2D) -> void:
	if entered_body.is_in_group("player"):
		entered_body.dying = true