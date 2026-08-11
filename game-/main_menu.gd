extends Node2D

func _ready():
	$Control/PlayMemory.pressed.connect(func(): get_tree().change_scene_to_file("res://memory_game.tscn"))
	$Control/PlayReaction.pressed.connect(func(): get_tree().change_scene_to_file("res://reaction_game.tscn"))
	$Control/Quit.pressed.connect(func(): get_tree().quit())
