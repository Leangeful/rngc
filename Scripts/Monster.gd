tool
extends Node2D

var bodypart_scene = preload("res://Scenes/BodyPart.tscn")
var modify_polygon = preload("res://Scripts/modify_polygon.gd")

onready var game_node = get_parent()
onready var joint_distance = game_node.window_size.y * 0.01

onready var bodypart_size = Vector2(game_node.window_size.y * 0.5, game_node.window_size.y * 0.5)
var max_variation = 0.2
var min_radius = 5
var rng

var head_node
var body_node
var neck_joint


func new(new_rng):
	self.rng = new_rng
	add_head()
	add_body()
	neck_joint = add_joint(head_node, body_node, get_neck_position())
	
func add_joint(node_a, node_b, pos):
	var new_joint = PinJoint2D.new()
	new_joint.node_a = node_a.get_path()
	new_joint.node_b = node_b.get_path()
	new_joint.bias = 0.9
	new_joint.disable_collision = false
	new_joint.position = pos
	add_child(new_joint)
	
	return new_joint
	

func add_head():
	head_node = add_bodypart(Vector2(0,0))
	
func add_body():
	var dist = joint_distance
	dist += get_max_y(head_node)
	body_node = add_bodypart(Vector2(0, dist), true)

func add_bodypart(pos, add_y = false):
	var part_instance = bodypart_scene.instance()
	var part_polygon = part_instance.get_child(0)
	var part_collision = part_instance.get_child(1)
	var vertex_count = rng.randi_range(3, 6)
	
	part_polygon.size = bodypart_size
	
	if vertex_count == 6:
		vertex_count = 100
		var mod_vector = Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
		
		part_polygon.size.x += mod_vector.x *rng.randi_range(0, int(part_polygon.size.x * max_variation))
		part_polygon.size.y += mod_vector.y *rng.randi_range(0, int(part_polygon.size.y * max_variation))
		part_polygon.size *= 0.8
	elif vertex_count == 5:
		part_polygon.size *= 0.9
		
	part_polygon.vertex_count = vertex_count
	part_polygon.new_polygon()
	
	var rnd_range = part_polygon.size * 0.1
	part_polygon.base_polygon = modify_polygon.randomize_polygon(part_polygon.base_polygon, rnd_range, rng)
	
	var min_x = ((part_polygon.size.x / 2) - part_polygon.size.x * max_variation) * 0.8
	var min_y = ((part_polygon.size.y / 2) - part_polygon.size.y * max_variation) * 0.8
	var max_radius = min(min_x, min_y)
	part_polygon.round_corners(rng, Vector2(min_radius, max_radius))
		
	part_collision.polygon = part_polygon.polygon
	
	if add_y:
		pos.y += get_min_y(part_instance)
	
	part_instance.position = pos
	part_polygon.color = Color(rng.randf(), rng.randf(), rng.randf())
	
	self.add_child(part_instance, true)
	return part_instance

func get_neck_position():
	var pos = Vector2(0, 0)
	pos.y = get_max_y(head_node) + joint_distance / 2	
	return Vector2(0, pos.y)

func get_max_y(n):
	var max_y = 0
	for p in n.get_child(0).polygon:
		if p.y > max_y:
			max_y = p.y
	return max_y

func get_min_y(n):
	var min_y = null
	for p in n.get_child(0).polygon:
		if min_y == null:
			min_y = p.y
		if p.y < min_y:
			min_y = p.y
	return abs(min_y)
