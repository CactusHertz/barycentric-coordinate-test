extends Node3D
class_name CollisionGeometry

var mesh_inst : MeshInstance3D = get_parent() 
var origin_node : Node3D = mesh_inst.get_parent()

var mesh_data_array : Array[MeshDataTool]
var mesh_face_count : Array[int]


func _ready() -> void:
	if not mesh_inst:
		push_error("mesh not set")
		return
	
	for surface in mesh_inst.get_surface_override_material_count():
		var mesh_data: MeshDataTool = MeshDataTool.new()
		mesh_data.create_from_surface(mesh_inst.mesh, surface)
		mesh_data_array.append(mesh_data)
		mesh_face_count.append(mesh_data.get_face_count())


func get_vertex_normals_at_face_index(index: float) -> Array[Vector3]:
	var normals: Array[Vector3] = []
	for i in range(0, 3):
		var total_index = 0
		for surface in len(mesh_data_array):
			if index < total_index + mesh_face_count[surface]:
				var surface_index = index - total_index
				normals.append(
					mesh_data_array[surface].get_vertex_normal(
						mesh_data_array[surface].get_face_vertex(surface_index, i)
					)
				)
				break
			total_index += mesh_face_count[surface]
	return normals


func get_vertex_positions_at_face_index(index: float) -> Array[Vector3]:
	var vertices: Array[Vector3] = []
	for i in range(0, 3):
		var total_index = 0
		for surface in len(mesh_data_array):
			if index < total_index + mesh_face_count[surface]:
				var surface_index = index - total_index
				vertices.append(
					origin_node.global_transform * mesh_data_array[surface].get_vertex(
						mesh_data_array[surface].get_face_vertex(surface_index, i)
					)
				)
				break
			total_index += mesh_face_count[surface]
	return vertices
