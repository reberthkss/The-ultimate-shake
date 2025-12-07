extends Node2D

func _ready() -> void:
	$BaseLevel.show_bottom_bubbles()

func _on_base_level_on_next_level() -> void:
	get_tree().change_scene_to_file("res://levels/400-600/Level_400_600.tscn")
