extends Node3D
class_name CollisionGeometry

@export var mesh_inst : MeshInstance3D
@export var origin_node : Node3D
var mesh: Mesh
var mesh_data: MeshDataTool
var origin_offset := Vector3.ZERO

func _ready() -> void:
	if not mesh_inst:
		push_error("mesh not set")
		return
	mesh_data = MeshDataTool.new()
	mesh_data.create_from_surface(mesh_inst.mesh,0)

func get_vertex_normals_at_face_index(index: float) -> Array[Vector3]:
	var normals: Array[Vector3] = []
	for i in range(0, 3):
		normals.append(mesh_data.get_vertex_normal(mesh_data.get_face_vertex(index, i)))
	return normals

func get_vertex_positions_at_face_index(index: float) -> Array[Vector3]:
	var origin_offset := Vector3.ZERO
	if origin_node: 
		origin_offset = origin_node.transform.origin
	var vertices: Array[Vector3] = []
	for i in range(0, 3):
		vertices.append(mesh_data.get_vertex(mesh_data.get_face_vertex(index, i)) + origin_offset)
	return vertices

