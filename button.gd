extends Button

var exit_node : ExitNode

func _ready() -> void:
	exit_node =  get_child(0)

func _on_pressed() -> void:
	exit_node.exit_map()
