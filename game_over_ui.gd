extends Control


func _on_restart_button_pressed() -> void:
	# Unpause the game before reloading!
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_reset_high_score_button_pressed() -> void:
	GameManager.reset_high_score()
