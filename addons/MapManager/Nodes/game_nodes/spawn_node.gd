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
		
@export var global_spawn : bool = false : 
	set(value):
		if Engine.is_editor_hint():
			if value == true:
				global_spawn = value
				add_global_spawn()
			else:
				if MapManager.connections_dictionary.has(name):
					connection_dictionary.clear()
					MapManager.connections_dictionary.erase(name)
				global_spawn = value
	get:
		return global_spawn

signal spawn_found

var connection_dictionary : Dictionary = {}


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


func add_global_spawn():
	if Engine.is_editor_hint():
		connection_dictionary["location"] = MapManager.map_dictionary[map_name]["file_location"]
		connection_dictionary["spawn_point"] = UID
		
		MapManager.connections_dictionary[name] = connection_dictionary
		var map_save : MapSaveFile
		
		map_save = MapSaveFile.new()
		map_save.save_map_manager(map_save)
