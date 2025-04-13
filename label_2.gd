extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_child(0).spawn_found.connect(_on_spawn)
	
func _on_spawn():
	text = "I am the spawn to find"
