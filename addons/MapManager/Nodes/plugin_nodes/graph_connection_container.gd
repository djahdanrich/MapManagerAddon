@tool
extends PanelContainer
class_name ConnectionsPanel

@onready var spawn_name: Label = $HBoxContainer/VBoxContainer/SpawnName
@onready var spawn_uid: Label = $HBoxContainer/VBoxContainer/SpawnUID
@onready var exit_name: Label = $HBoxContainer/VBoxContainer2/ExitName
@onready var exit_uid: Label = $HBoxContainer/VBoxContainer2/ExitUID

var turn_on_left : bool = true
var turn_on_right : bool = true
var spawn_dict : Dictionary
var spawn_UID : String
var exit_dict : Dictionary
var exit_UID : String
var slot_index : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_labels()
	turn_on_graph()

func set_labels():
	slot_index = get_index() - 2
	
	if slot_index <= spawn_dict.keys().size():
		for spawn_keys in spawn_dict.keys().size():
			var spawn_UIDs = spawn_dict.keys()
			var my_spawn_UID = spawn_UIDs[slot_index]
			var spawn_title = spawn_dict[my_spawn_UID]["name"]
			
			spawn_name.text = spawn_title
			spawn_uid.text = my_spawn_UID
			spawn_UID = my_spawn_UID
			turn_on_left = true
		
	else:
		spawn_name.text = ""
		spawn_uid.text = ""
		turn_on_left = false
	
	
	if slot_index < exit_dict.keys().size():
		for exit_keys in exit_dict.keys().size():
			var exit_UIDs = exit_dict.keys()
			var my_exit_UID = exit_UIDs[slot_index]
			var exit_title = exit_dict[my_exit_UID]["name"]
			
			exit_name.text = exit_title
			exit_uid.text = my_exit_UID
			exit_UID = my_exit_UID
			turn_on_right = true
		
	else:
		exit_name.text = ""
		exit_uid.text = ""
		turn_on_right = false


func turn_on_graph():
	if get_parent() is GraphMapLoader:
		get_parent().set_slot(slot_index + 1, turn_on_left, 0, Color.WHITE, turn_on_right, 0, Color.WHITE)
