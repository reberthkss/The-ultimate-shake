extends CanvasLayer


@onready var msg = $CenterContainer/VBoxContainer/Label
@onready var exitBtn = $CenterContainer/VBoxContainer/Exit

func _ready():
	visible = false
	

func show_result(win: bool):
	visible = true
	get_tree().paused = true
	
	if win:
		msg.text = "Voce venceu!"
		msg.modulate = Color.GREEN
	else :
		msg.text = "Voce perdeu!"
		msg.modulate = Color.RED


func _on_exit_pressed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu/main/MainMenu.tscn")
