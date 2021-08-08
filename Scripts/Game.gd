tool
extends Node2D


var held_object = null

var monster = preload("res://Scenes/Monster.tscn")

var rng = RandomNumberGenerator.new()

var window_size = Vector2(1920, 1080) #for testing

func _ready():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.connect("clicked", self, "_on_pickable_clicked")
		

func _on_pickable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_speed())
			held_object = null


func _on_Button_button_up():
	add_monster()
	
func add_monster():
	var monster_instance = monster.instance()	
	rng.randomize()
	add_child(monster_instance)
	monster_instance.new(rng)
	monster_instance.position = Vector2(window_size.x / 2, window_size.y * 0.4)
	
		
	for node in get_tree().get_nodes_in_group("pickable"):
		if not node.is_connected("clicked", self, "_on_pickable_clicked"):
			node.connect("clicked", self, "_on_pickable_clicked")


func _on_Button2_button_up():
	for node in get_tree().get_nodes_in_group("monster"):
		node.queue_free()
