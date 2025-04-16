@tool
extends Node
class_name MapManagerPlugin

@export var map_container : String
@export var map_dictionary : Dictionary = {}
@export var connections_dictionary : Dictionary = {}
@export var constant_dict : Dictionary = {}

@onready var map_manager_editor : MapManagerEditor

signal start_transition
signal new_map_loaded
signal end_transition
signal spawn_found(spawn : SpawnNode)
signal exit_found(exit : ExitNode)
signal alert_constant_node(exit : ExitNode)
signal reparent_constant(constant : ConstantNode)

var loaded_map : bool = false
var is_armed : bool
var spawn_points : Array[String]
var exit_points : Array[String]
var spawn_to_find : String
var current_map

func _ready() -> void:
	if !Engine.is_editor_hint():
		var map_load : MapSaveFile = MapSaveFile.new()
		map_load.load_for_game()
		reparent_constant.connect(process_reparent)


func get_random_id() -> String:
	randomize()
	return str(randi() % 1000000).sha1_text().substr(0, 10)


func set_armed():
	spawn_points.clear()
	exit_points.clear()
	is_armed = true


func set_disarmed():
	is_armed = false


func listen_for_spawn(spawn : SpawnNode):
	if is_armed:
		spawn_points.insert(0, spawn.UID)
		spawn_found.emit(spawn)
		
	if !Engine.is_editor_hint():
		await new_map_loaded
		if spawn.UID == spawn_to_find:
			spawn_found.emit(spawn)


func listen_for_exit(exit : ExitNode):
	if is_armed:
		exit_points.insert(0, exit.UID)
		exit_found.emit(exit)


func move_maps(UID : String, exit_owner : Node):
	var new_map : PackedScene
	var old_map = exit_owner
	var spawn_point : SpawnNode
	
	start_transition.emit()
	spawn_to_find = connections_dictionary[UID]["spawn_point"]
	new_map = load(connections_dictionary[UID]["location"])
	
	var instanced_new_map = new_map.instantiate()
	old_map.get_parent().add_child(instanced_new_map)
	
	print("Map Changed from: ", old_map.name, " to: ", instanced_new_map.name)
	print("by: ", UID, " to go to: ", spawn_to_find, " \n")
	
	current_map = instanced_new_map
	
	
	old_map.queue_free()
	new_map_loaded.emit()


func alert_constant(exit_node : ExitNode):
	alert_constant_node.emit(exit_node)


func process_reparent(constant : ConstantNode):
	var constant_parent = constant.get_parent()
	constant_parent.get_parent().remove_child(constant_parent)
	
	await new_map_loaded
	
	current_map.add_child(constant_parent)
	
	if constant.move_to_spawn:
		var spawn_to = await spawn_found
		var spawn_parent = spawn_to.get_parent()
		
		constant_parent.global_position = spawn_parent.global_position
