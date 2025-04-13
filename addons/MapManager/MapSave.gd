extends Resource
class_name MapSaveFile


const GRAPH_NODE = preload("res://addons/MapManager/Nodes/plugin_nodes/graph_node.tscn")

@export var map_container : String
@export var map_dictionary : Dictionary = {}
@export var connections_dictionary : Dictionary = {}

var save_location : String = "res://addons/MapManager/save_data/"


func save_map_manager(save_file : MapSaveFile):
	map_container = MapManager.map_container
	
	for graph_node in MapManager.map_manager_editor.graph_workspace.get_children():
		if graph_node is GraphMapLoader:
			graph_node._on_position_offset_changed()
	
	map_dictionary = MapManager.map_dictionary
	connections_dictionary = MapManager.connections_dictionary
	
	var err = ResourceSaver.save(save_file, "res://addons/MapManager/save_data/map_save.tres", ResourceSaver.FLAG_CHANGE_PATH)
	
	if not err:
		print("map manager saved without error")
	else:
		print("map manager error: ", err)


func load_map_manager():
	var loaded_save = ResourceLoader.load(save_location + "map_save.tres")
	MapManager.map_container = loaded_save.map_container
	MapManager.map_dictionary = loaded_save.map_dictionary
	MapManager.connections_dictionary = loaded_save.connections_dictionary
	
	var map_manager_editor : MapManagerEditor = MapManager.map_manager_editor
	var map_editor_graph : GraphEdit = map_manager_editor.graph_workspace
	var map_dictionary = MapManager.map_dictionary
	var connections_dictionary = MapManager.connections_dictionary
	
	if map_editor_graph:
		map_editor_graph.clear_connections()
	
	for child in map_editor_graph.get_children():
		if child is GraphMapLoader:
			child.queue_free()
	
	
	for key in MapManager.map_dictionary:
		var new_node = GRAPH_NODE.instantiate()
		var node_position : Vector2 = MapManager.map_dictionary[key]["node_position"]
		
		new_node.parent = MapManager.map_manager_editor
		map_manager_editor.graph_workspace.add_child(new_node)
		
		new_node.set_position_offset(MapManager.map_dictionary[key]["node_position"])
		new_node._file_selected(MapManager.map_dictionary[key]["file_location"])
	
	for conn_key in connections_dictionary:
		var from_node : String
		var from_port : int
		var to_node : String
		var to_port : int
	#
		for graph_node in map_manager_editor.graph_workspace.get_children():
			if graph_node is GraphMapLoader:
				for map_key in map_dictionary:
					if graph_node.scene_location == map_dictionary[map_key]["file_location"]:
						if graph_node.my_dict["exits"].has(conn_key):
							from_node = graph_node.name
						
					if graph_node.scene_location == connections_dictionary[conn_key]["location"]:
						if graph_node.my_dict["spawns"].has(connections_dictionary[conn_key]["spawn_point"]):
							to_node = graph_node.name
						
						for connections_panel in graph_node.get_children():
							if connections_panel is ConnectionsPanel:
								if connections_panel.exit_UID == conn_key:
									from_port = connections_panel.slot_index
									
								if connections_panel.spawn_UID == connections_dictionary[conn_key]["spawn_point"]:
									to_port = connections_panel.slot_index
									
		map_manager_editor.graph_workspace.connect_node(from_node, from_port, to_node, to_port)
		
func load_for_game():
	var loaded_save = ResourceLoader.load(save_location + "map_save.tres")
	MapManager.map_dictionary = loaded_save.map_dictionary
	MapManager.connections_dictionary = loaded_save.connections_dictionary
