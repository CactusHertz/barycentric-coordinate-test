extends Node3D

var rot_axis := Vector3(0,100,0)

var rot_speed := 0.01



func _process(delta):
	var input_vector := Input.get_vector("right", "left", "forward", "back")

	rotate_object_local(Vector3(0, 1, 0), rot_speed * input_vector.x)
	
