@tool
extends Control
class_name MapManagerEditor

const GRAPH_NODE = preload("res://addons/MapManager/Nodes/plugin_nodes/graph_node.tscn")
const MapSave = preload("res://addons/MapManager/MapSave.gd")

@onready var popup_menu: PopupMenu = $Main/Workspace/PopupMenu
@onready var file_menu: MenuButton = $Main/ToolBar/FileMenu
@onready var add_menu: MenuButton = $Main/ToolBar/AddMenu
@onready var graph_workspace: GraphEdit = $Main/Workspace/GraphWorkspace
@onready var file_directory

signal open_file_directory

var pop_up_position : Vector2
var loaded_map_manager : MapSaveFile

func _ready() -> void:
	var menu_popup = add_menu.get_popup()
	var file_popup = file_menu.get_popup()
	menu_popup.id_pressed.connect(_on_popup_menu_id_pressed)
	file_popup.id_pressed.connect(_on_file_menu_id_pressed)
	open_file_directory.connect(_open_file)
	graph_workspace.add_valid_left_disconnect_type(0)


func _on_graph_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		popup_menu.position = get_global_mouse_position()
		popup_menu.show()


func _on_popup_menu_id_pressed(id: int) -> void:
	match  id:
		0:
			var new_map = GRAPH_NODE.instantiate()
			new_map.parent = self
			graph_workspace.add_child(new_map)


func _on_file_menu_id_pressed(id : int):
	match id:
		0:
			print("Load MapData")
			var map_load : MapSaveFile = MapSaveFile.new()
			map_load.load_map_manager()
			loaded_map_manager = map_load
		1:
			print("Save MapData")
			var map_save : MapSaveFile
			
			map_save = MapSaveFile.new()
			map_save.save_map_manager(map_save)
			
		2:
			print("Delete MapData")
			DirAccess.remove_absolute("res://addons/MapManager/save_data/map_save.tres")
		
			for child in graph_workspace.get_children():
				if child is GraphMapLoader:
					child.queue_free()
					
					
			MapManager.map_dictionary.clear()
			MapManager.connections_dictionary.clear()


func _enter_tree():
	file_directory = FileDialog.new()
	file_directory.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	file_directory.access = FileDialog.ACCESS_RESOURCES
	file_directory.ok_button_text = "Open"
	var filters : PackedStringArray
	filters.insert(0, "*.tscn")
	file_directory.set_filters(filters)
	# ... more config
	file_directory.file_selected.connect(_on_FileDialog_file_selected)
	file_directory.hide()
	add_child(file_directory)


func _open_file(graph_that_requested_open):
	file_directory.popup_centered_ratio()
	file_directory.file_selected.connect(graph_that_requested_open._file_selected)


func _on_FileDialog_file_selected(path):
	pass
	#var scene = load(path)


func _on_graph_workspace_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_workspace.connect_node(from_node, from_port, to_node, to_port)
	var from_node_as_node : GraphMapLoader
	var from_slot_as_node : ConnectionsPanel 
	var to_node_as_node : GraphMapLoader
	var to_slot_as_node : ConnectionsPanel 
	var connection_dictionary : Dictionary
	
	for child in graph_workspace.get_children():
		if child.name == from_node:
			from_node_as_node = child
			break
	
	
	for child in graph_workspace.get_children():
		if child.name == to_node:
			to_node_as_node = child
			break
	
	from_slot_as_node = from_node_as_node.get_child(from_port + 1)
	to_slot_as_node = to_node_as_node.get_child(to_port + 1)
	
	connection_dictionary["location"] = to_node_as_node.scene_location
	connection_dictionary["spawn_point"] = to_slot_as_node.spawn_UID
	
	
	MapManager.connections_dictionary[from_slot_as_node.exit_UID] = connection_dictionary
	
	print(MapManager.connections_dictionary)


func _on_graph_workspace_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_workspace.disconnect_node(from_node, from_port, to_node, to_port)
	
	var from_node_as_node : GraphMapLoader
	var from_slot_as_node : ConnectionsPanel
	
	for child in graph_workspace.get_children():
		if child.name == from_node:
			from_node_as_node = child
			break
	
	from_slot_as_node = from_node_as_node.get_child(from_port + 1)
	
	MapManager.connections_dictionary.erase(from_slot_as_node.exit_UID)
	
	print(MapManager.connections_dictionary)


func _on_visibility_changed() -> void:
	MapManager.map_manager_editor = self
	if visible:
		if !MapManager.loaded_map:
			if ResourceLoader.exists("res://addons/MapManager/save_data/map_save.tres"):
				var map_load : MapSaveFile = MapSaveFile.new()
				map_load.load_map_manager()
				MapManager.loaded_map = true
	else:
		var map_save : MapSaveFile
		map_save = MapSaveFile.new()
		map_save.save_map_manager(map_save)
		
	print(MapManager.map_dictionary)
