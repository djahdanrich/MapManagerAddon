@tool
extends GraphNode
class_name GraphMapLoader

const GRAPH_CONNECTION_CONTAINER = preload("res://addons/MapManager/Nodes/plugin_nodes/graph_connection_container.tscn")

@onready var load_scene: Button = $FunctionArea/VBoxContainer/NoSceneLoaded/LoadScene
@onready var unload_scene: Button = $FunctionArea/VBoxContainer/SceneLoaded/VBoxContainer/UnloadScene
@onready var no_scene_loaded: PanelContainer = $FunctionArea/VBoxContainer/NoSceneLoaded
@onready var scene_loaded: PanelContainer = $FunctionArea/VBoxContainer/SceneLoaded

signal arm_to_listen
signal disarm_to_listen
signal on_load_scene(who_requested_load)

var parent : Control
var scene_location : String
var map_name : String
var my_dict : Dictionary = {}
var spawn_dict : Dictionary = {}
var exit_dict : Dictionary = {}
var my_position : Vector2

func _ready() -> void:
	load_scene.pressed.connect(load_scene_pressed)
	if parent:
		on_load_scene.connect(parent._open_file)
	unload_scene.pressed.connect(unload_scene_pressed)
	
	arm_to_listen.connect(MapManager.set_armed)
	disarm_to_listen.connect(MapManager.set_disarmed)
	
	if MapManager.map_dictionary.has(map_name):
		position_offset = MapManager.map_dictionary[map_name]["node_position"]


func load_scene_pressed():
	on_load_scene.emit(self)


func _input(event: InputEvent) -> void:
	if event is InputEventKey && selected && is_visible_in_tree():
		if Input.is_key_pressed(KEY_DELETE):
			queue_free()


func unload_scene_pressed():
	scene_location = ""
	no_scene_loaded.show()
	scene_loaded.hide()
	my_dict.clear()
	MapManager.map_dictionary.erase(map_name)
	
	for child in get_children():
		if child is ConnectionsPanel:
			child.queue_free()


func _file_selected(file_path : String):
	if parent && parent.file_directory.file_selected.is_connected(_file_selected):
		parent.file_directory.file_selected.disconnect(_file_selected)
	
	
	no_scene_loaded.hide()
	scene_loaded.show()
	MapManager.set_armed()
	MapManager.spawn_found.connect(store_spawn)
	MapManager.exit_found.connect(store_exit)
	process_load(file_path)
	process_dictionary()
	build_graph()
	MapManager.set_disarmed()
	MapManager.spawn_found.disconnect(store_spawn)
	
func process_load(file_path : String):
	var load_map = load(file_path)
	scene_location = file_path
	var new_map = load_map.instantiate()
	add_child(new_map)
	map_name = new_map.name
	set_title(map_name)
	new_map.queue_free()


func store_spawn(spawn : SpawnNode):
	var found_spawn_dict : Dictionary = {}
	
	found_spawn_dict["name"] = spawn.name
	found_spawn_dict["map_name"] = spawn.map_name
	
	spawn_dict[spawn.UID] = found_spawn_dict


func store_exit(exit : ExitNode):
	var found_exit_dict : Dictionary = {}
	
	found_exit_dict["name"] = exit.name
	found_exit_dict["map_name"] = exit.map_name
	
	exit_dict[exit.UID] = found_exit_dict


func process_dictionary():
	my_dict["node_position"] = my_position
	my_dict["file_location"] = scene_location
	my_dict["spawns"] = spawn_dict
	my_dict["exits"] = exit_dict
	
	MapManager.map_dictionary[map_name] = my_dict
	return


func build_graph():
	var amount_of_connections : int
	var amount_of_spawns = my_dict["spawns"].size()
	var amount_of_exits = my_dict["exits"].size()
	
	if amount_of_spawns >= amount_of_exits:
		amount_of_connections = amount_of_spawns
	else:
		amount_of_connections = amount_of_exits
	
	for connection in amount_of_connections:
		var new_connection = GRAPH_CONNECTION_CONTAINER.instantiate()
		new_connection.spawn_dict = my_dict["spawns"]
		new_connection.exit_dict = my_dict["exits"]
		add_child(new_connection)
		
	return


func _on_position_offset_changed() -> void:
	if MapManager.map_dictionary.has(map_name):
		my_position = position_offset
		MapManager.map_dictionary[map_name]["node_position"] = my_position
