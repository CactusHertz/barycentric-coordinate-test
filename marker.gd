extends Node3D

func _process(delta):
	var input_vector := Input.get_vector("right", "left", "forward", "back")

	#apply_torque(Vector3(0,input_vector.x,0))
	
