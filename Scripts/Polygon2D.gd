tool
extends Polygon2D

export var vertex_count = 3 setget set_vertex_count
export var size = Vector2(100, 100) setget set_size
export var has_round_corners = false setget set_round_corners
export var radius = 10 setget set_radius

var modify_polygon = preload("res://Scripts/modify_polygon.gd")

export var base_polygon = PoolVector2Array()

#func _enter_tree():
#	new_polygon()

func _exit_tree():
	pass

func new_polygon():
	antialiased = true
	base_polygon = PoolVector2Array()
	var increment = 2 * PI / vertex_count
	var r_offset = deg2rad(get_rotation_offset())
	var curr_angle = 0.0 + r_offset
	while curr_angle < 2 * PI + r_offset:
		base_polygon.push_back(Vector2(cos(curr_angle) * size.x / 2, sin(curr_angle) * size.y / 2))
		curr_angle += increment
	
	if base_polygon[0] == base_polygon[base_polygon.size()-1]:
		base_polygon.remove(base_polygon.size()-1)
	
	polygon = base_polygon
	#if round_corners:
		#polygon = modify_polygon.round_corners(base_polygon, radius)
	

func set_vertex_count(new_count):
	if new_count >= 3:
		vertex_count = new_count
		#new_polygon()

func set_size(new_size):
	if new_size.x and new_size.y:
		size = new_size
		#new_polygon()

func set_round_corners(new_state):
	has_round_corners = new_state
#	if round_corners:
#		polygon = modify_polygon.round_corners(base_polygon, radius)
#	else:
#		polygon = base_polygon

func set_radius(new_radius):
	if new_radius > 0:
		radius = new_radius
		#new_polygon()
	

func get_rotation_offset():
	if not vertex_count % 2:
		if not vertex_count % 4:
			return 90 / (vertex_count / 2)
	else:
		if not vertex_count % 3:
			return 30
		if vertex_count % 3 == 1:
			return 90 / vertex_count
		if vertex_count % 3 == 2:
			return -90	
	return 0

func round_corners(rng = null, rnd_range = null):
	if vertex_count == 100:
		return
	polygon = modify_polygon.round_corners(base_polygon, radius, rng, rnd_range)
