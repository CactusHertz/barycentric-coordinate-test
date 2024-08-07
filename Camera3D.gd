extends Camera3D

#var marker = preload("res://marker.tscn")
@onready var marker = $"../marker"



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
	#print(raycast_result)
	
	if !raycast_result.is_empty():
		marker.visible = true
		marker.position = raycast_result["position"]
	else:
		marker.visible = false
	
'''	if !raycast_result.is_empty():
		var instance = marker.instantiate()
		instance.position = raycast_result["position"]
		$'../'.add_child(instance)
'''
