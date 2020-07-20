extends CollisionShape2D

func is_colliding():
	var areas = get_overlapping_areas()
	
