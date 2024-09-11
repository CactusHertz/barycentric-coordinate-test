extends Node3D

var rot_axis := Vector3(0,100,0)

var rot_speed := 0.01

@onready var ray_cast = $RayCast3D

@export var debug_output = false

var up_normal := Vector3.DOWN


func _process(delta):
	var input_vector := Input.get_vector("right", "left", "forward", "back")

	rotate_object_local(Vector3(0, 1, 0), rot_speed * input_vector.x)
	align_to_floor(up_normal)


func align_to_floor(up_normal: Vector3):
	var forward = self.transform.basis.z
	var up = up_normal.normalized()
	var right = up.cross(forward).normalized()
	forward = right.cross(up).normalized()
	var new_basis = Basis(right, up, forward)
	self.transform.basis = new_basis
