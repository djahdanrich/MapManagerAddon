@tool
extends EditorPlugin

const ICON_MAP : Texture2D = preload("res://addons/MapManager/icon_map.png")
const MAPMANAGER = preload("res://addons/MapManager/MapManagerEditor.tscn")
const SAVE_LOCATION : String = "res://addons/MapManager/save_data/"

var main_panel_instance


func _enter_tree():
	if Engine.is_editor_hint():
		main_panel_instance = MAPMANAGER.instantiate()
		EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
		_make_visible(false)
		add_autoload_singleton("MapManager", "res://addons/MapManager/MapManager.gd")

func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()
		main_panel_instance.file_directory.queue_free()
		
	remove_autoload_singleton("MapManager")


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible
		


func _get_plugin_name():
	return "Map Manager"


func _get_plugin_icon():
	return ICON_MAP
