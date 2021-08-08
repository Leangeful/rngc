extends Node

#https://stackoverflow.com/questions/24771828/how-to-calculate-rounded-corners-for-a-polygon
static func round_corners(polygon, radius, rng = null, rnd_range = null):
	
	if radius < 1:
		radius = 1	
	
	var new_points = PoolVector2Array()
	var polygon_size = polygon.size()
	
	var A = Vector2()
	var B = Vector2()
	var C = Vector2()
	
	for i in range(polygon_size):
		if rng and rnd_range:
			radius = rng.randi_range(rnd_range.x, rnd_range.y)
		var lod = int(radius / 4)

		if lod < 10:
			lod = 10
		
		B = polygon[i]
		if i == 0:
			A = polygon[polygon_size - 1]
			C = polygon[i + 1]
		elif i == polygon_size - 1:
			A = polygon[i - 1]
			C = polygon[0]
		else:
			A = polygon[i - 1]
			C = polygon[i + 1]
		
		
		var BA = Vector2(B.x - A.x, B.y - A.y)
		var BC = Vector2(B.x - C.x, B.y - C.y)
		
		var angle = atan2(BA.y, BA.x) - atan2(BC.y, BC.x)
		
		var segment = radius / abs(tan(angle/2))
		
		var len1 = get_length(BA)
		var len2 = get_length(BC)
		
		#var length = min(len1, len2)			
		
		#var length_BO = sqrt (pow(radius, 2) + pow(segment, 2))
		
		var F1 = get_proportion_point(B, segment, len1, BA)
		var F2 = get_proportion_point(B, segment, len2, BC)
		
		#point O is the center of the circle
		var O = Vector2()
		O.x = B.x * 2 - F1.x - F2.x 
		O.y = B.y * 2 - F1.y - F2.y
		
		var L = get_length(O)
		var d = get_length(Vector2(segment, radius))
		
		var circle_point = get_proportion_point(B, d, L, O)
		
		var start_angle = atan2(F1.y - circle_point.y, F1.x - circle_point.x);
		var end_angle = atan2(F2.y - circle_point.y, F2.x - circle_point.x);
		var sweep_angle = end_angle - start_angle;
		
		if abs(sweep_angle) > PI:
			if start_angle < 0:
				start_angle += 2*PI
			else:
				start_angle -= 2*PI
			
			sweep_angle = end_angle - start_angle
		
		
		var increment = sweep_angle / lod
		var curr_angle = start_angle
		
		if sweep_angle < 0:
			while curr_angle > end_angle:
				new_points.push_back(Vector2(circle_point.x + cos(curr_angle)* radius, circle_point.y + sin(curr_angle)* radius))
				curr_angle += increment
		else:
			while curr_angle < end_angle:
				new_points.push_back(Vector2(circle_point.x + cos(curr_angle)* radius, circle_point.y + sin(curr_angle)* radius) )
				curr_angle += increment
		
	return new_points
	
static func get_length(vec):
	return sqrt(vec.x * vec.x + vec.y * vec.y)

static func get_proportion_point(angular_point, segment, length, vec):
	var factor = segment / length
	return Vector2(angular_point.x - vec.x * factor, angular_point.y - vec.y * factor)

static func randomize_polygon(polygon,rnd_range, rng):
	
	var poly_size = polygon.size()
	if poly_size == 100:
		return polygon
		
	var mod_vectors = PoolVector2Array()
	
	for _i in range(poly_size):
		mod_vectors.push_back(Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1)))
	
	
	for i in range(poly_size):
		polygon[i].x += mod_vectors[i].x * rng.randi_range(0, int(rnd_range.x)) 
		polygon[i].y += mod_vectors[i].y * rng.randi_range(0, int(rnd_range.y)) 
	return polygon
