tool
extends RigidBody2D

onready var part_shape = get_child(0)
onready var part_collision = get_node("CollisionPolygon2D")

var is_dragged = false
signal clicked

func _physics_process(_delta):
	if is_dragged:
		global_transform.origin = get_global_mouse_position()
		global_rotation = 0.0

func pickup():
	if is_dragged:
		return
	mode = RigidBody2D.MODE_STATIC
	is_dragged = true

func drop(impulse = Vector2.ZERO):
	if is_dragged:
		mode = RigidBody2D.MODE_RIGID
		apply_central_impulse(impulse)
		is_dragged = false

func _on_BodyPart_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("clicked", self)

