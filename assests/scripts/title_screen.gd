extends Control

@onready var label1: Label = $Label
@onready var label2: Label= $Label2
@onready var player: CharacterBody2D = $"../Player"


func _process(_delta: float) -> void:
	if player.title_screning:
		label1.visible = true
		label2.visible = true
	else:
		label1.visible = false
		label2.visible = false
