@tool
extends Node
class_name ConstantNode


@export var UID : String
@export var reset_UID = false :
	set(value):
		if Engine.is_editor_hint():
			UID =_reset_UID(value)
	get:
		return false
		
@export var move_to_spawn : bool

func _ready() -> void:
	if Engine.is_editor_hint():
		if UID == "":
			UID = str("cn_" + MapManager.get_random_id())
	else:
		MapManager.alert_constant_node.connect(connect_to_exit)


func _reset_UID(reset : bool) -> String:
	print("UID Reset")
	if reset:
		var new_UID = str("sn_" + MapManager.get_random_id())
		return new_UID
	else:
		return UID

func connect_to_exit(exit_to_connect : ExitNode):
	exit_to_connect.move_requested.connect(emancipate_parent)
	
func emancipate_parent():
	var parent = get_parent()
	MapManager.reparent_constant.emit(self)
