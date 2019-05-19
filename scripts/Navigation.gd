extends Navigation

func _ready():
	pass


func a_GenPath(from, to):
	var aGendPath = get_simple_path(from, to, true)
	return aGendPath


func a_GetDistance(from, to):
	var aDistance = from.distance_to(to)
	return aDistance