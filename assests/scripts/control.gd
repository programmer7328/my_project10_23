extends Control

@onready var win_label: Label = $Label
@onready var time_label: Label= $Label2
@onready var high_score_label: Label= $Label3
@onready var coin_label: Label= $Label4
@onready var player: CharacterBody2D = $"../Player"

var time = 0
var high_score = 0


func load_high_score():
	if FileAccess.file_exists("user://save.dat"):
		var file = FileAccess.open("user://save.dat", FileAccess.READ)
		high_score = file.get_64()
		file.close()

func save_high_score():
	var file = FileAccess.open("user://save.dat", FileAccess.WRITE)
	file.store_64(high_score)
	file.close()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_high_score()
	win_label.visible = false
	time_label.visible = false
	high_score_label.visible = false
	coin_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if not player.winning:
		time += delta

	if player.winning == true:
		win_label.visible = true
		time_label.visible = true
		high_score_label.visible = true
		coin_label.visible = true
		time_label.text = "Time: "+(str(snappedf(time, 0.1)))+"sec"
		if time < high_score:
			high_score = time
			save_high_score()
		high_score_label.text = "High Score: "+(str(snappedf(high_score, 0.1)))+"sec"
		coin_label.text = "Coins: "+(str(player.coin))+"/5"
	else:
		win_label.visible = false
		time_label.visible = false

	


