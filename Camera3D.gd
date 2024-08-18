extends Camera3D

#var marker = preload("res://marker.tscn")
@onready var marker = $"../marker"

@onready var label = $"../CanvasLayer/HBoxContainer/VBoxContainer/Label"

const DOT = preload("res://dot.tscn")
var dots : Array[MeshInstance3D]
@onready var level = $".."


func _ready():
	for x in range(3):
		var dot_instance = DOT.instantiate()
		level.add_child.call_deferred(dot_instance)
		dots.append(dot_instance)


func _process(delta):
	shoot_ray()

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()

	ray_query.from = from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	label.text = str(raycast_result)
	
	if !raycast_result.is_empty():
		marker.visible = true
		marker.position = raycast_result["position"]


		var col = raycast_result["collider"]
		var vertices = col.get_vertex_positions_at_face_index(raycast_result["face_index"])
	
		var vertex_normals = col.get_vertex_normals_at_face_index(raycast_result["face_index"])
		if Input.is_action_just_pressed("click"):
			print("vetices: " + str(vertices))
			print("normals: " + str(vertex_normals))
		var bary_coords: Vector3 = Geometry3D.get_triangle_barycentric_coords(raycast_result["position"], vertices[0], vertices[1], vertices[2])
		var up_normal: Vector3 = (vertex_normals[0] * bary_coords.x) + (vertex_normals[1] * bary_coords.y) + (vertex_normals[2] * bary_coords.z)
		up_normal = up_normal.normalized()
		marker.up_normal = up_normal
		
		for x in range(3):
			dots[x].position = vertices[x]
			dots[x].rotation = vertex_normals[x]


		#align_to_floor(up_normal, marker)
		#align_to_floor(raycast_result["normal"], marker)

	else:
		marker.visible = false
	
	
func align_to_floor(up_normal: Vector3, marker: Node3D):
	var forward = marker.transform.basis.z
	var up = up_normal.normalized()
	var right = up.cross(forward).normalized()
	forward = right.cross(up).normalized()
	var new_basis = Basis(right, up, forward)
	marker.transform.basis = new_basis


