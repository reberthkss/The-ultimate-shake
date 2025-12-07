extends Node2D

func _ready() -> void:
	$BaseLevel.show_bottom_bubbles()

func _on_base_level_on_next_level() -> void:
	get_tree().change_scene_to_file("res://levels/600-800/Level_600_800.tscn")
