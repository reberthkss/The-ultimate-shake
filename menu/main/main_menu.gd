extends Control


func _ready():
	return
	$Settings.hide()
	$Ranking.hide()

func _on_play_button_pressed() -> void:
	$ButtonsSound.play()
	get_tree().change_scene_to_file("res://levels/0-200/Level_0_200.tscn")


func _on_settings_pressed() -> void:
	$ButtonsSound.play()
	# TODO


func _on_ranking_pressed() -> void:
	$ButtonsSound.play()
	# TODO
