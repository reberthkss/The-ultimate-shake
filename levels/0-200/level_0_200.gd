extends Node2D


func _on_base_level_on_next_level() -> void:
	get_tree().change_scene_to_file("res://levels/200-400/Level_200_400.tscn")
