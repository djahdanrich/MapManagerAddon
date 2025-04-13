@tool
extends Node
class_name SpawnNode

@export var UID : String
@export var map_name : String
@export var reset_UID = false :
	set(value):
		if Engine.is_editor_hint():
			UID =_reset_UID(value)
	get:
		return false

signal spawn_found


func _ready() -> void:
	if Engine.is_editor_hint():
		if MapManager.is_armed:
			MapManager.listen_for_spawn(self)
			
		else:
			if UID == "":
				UID = str("sn_" + MapManager.get_random_id())
				
	else:
		MapManager.listen_for_spawn(self)


func _reset_UID(reset : bool) -> String:
	print("UID Reset")
	if reset:
		var new_UID = str("sn_" + MapManager.get_random_id())
		return new_UID
	else:
		return UID
