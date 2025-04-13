@tool
extends Node
class_name ExitNode

@export var UID : String
@export var map_name : String
@export var reset_UID = false :
	set(value):
		if Engine.is_editor_hint():
			UID =_reset_UID(value)
	get:
		return false

signal move_requested

var my_owner

func _ready() -> void:
	if Engine.is_editor_hint():
		if MapManager.is_armed:
			MapManager.listen_for_exit(self)
			
		else:
			if UID == "":
				UID = str("ex_" + MapManager.get_random_id())
	else:
		my_owner = owner
		await  get_tree().process_frame
		MapManager.alert_constant(self)


func _reset_UID(reset : bool) -> String:
	print("UID Reset")
	if reset:
		var new_UID = str("ex_" + MapManager.get_random_id())
		return new_UID
	else:
		return UID


func exit_map():
	move_requested.emit()
	await get_tree().process_frame
	MapManager.move_maps(UID, my_owner)
