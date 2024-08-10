extends Node3D

var rot_speed := Vector3(0,100,0)

func _process(delta):
	var input_vector := Input.get_vector("right", "left", "forward", "back")

	rotation_degrees += basis * rot_speed * delta * input_vector.x
	#apply_torque(Vector3(0,input_vector.x,0))
	
