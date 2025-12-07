extends Node2D

func _ready() -> void:
	$BaseLevel.show_bottom_bubbles()

func _on_base_level_on_next_level() -> void:
	$BaseLevel/EndScreen.show_result(true)
