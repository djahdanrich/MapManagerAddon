extends Button

func _on_pressed() -> void:
	MapManager.move_maps("SpawnToOne", owner)
