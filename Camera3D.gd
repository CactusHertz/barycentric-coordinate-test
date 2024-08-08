extends Camera3D

#var marker = preload("res://marker.tscn")
@onready var marker = $"../marker"

@onready var label = $"../CanvasLayer/HBoxContainer/VBoxContainer/Label"


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


		#set_up_direction(raycast_result["normal"], marker)
		marker.look_at(marker.global_position - raycast_result["normal"], marker.global_position)
		
		
		print(marker.rotation)
	else:
		marker.visible = false
	
func set_up_direction(up_normal: Vector3, node : Node3D) -> void:
	var new_basis: Basis = node.transform.basis
	new_basis.y = up_normal
	new_basis.x = -node.basis.z.cross(node.basis.y)
	new_basis = new_basis.orthonormalized()
	node.basis = new_basis
	
	
func get_vertex_normals_at_face_index(index: float, mesh_data: MeshDataTool) -> Array[Vector3]:
	var normals: Array[Vector3] = []
	for i in range(0, 3):
		normals.append(mesh_data.get_vertex_normal(mesh_data.get_face_vertex(index, i)))
	return normals

func get_vertex_positions_at_face_index(index: float, mesh_data: MeshDataTool) -> Array[Vector3]:
	var vertices: Array[Vector3] = []
	for i in range(0, 3):
		vertices.append(mesh_data.get_vertex(mesh_data.get_face_vertex(index, i)))
	return vertices

'''	if !raycast_result.is_empty():
		var instance = marker.instantiate()
		instance.position = raycast_result["position"]
		$'../'.add_child(instance)
'''
