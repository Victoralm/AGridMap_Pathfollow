extends "res://scripts/CharacterTemplate.gd"

onready var timer = $Timer
onready var nav = get_parent()
onready var targets = get_tree().get_nodes_in_group("target")
#onready var gridmap = get_parent().get_node('GridMap')
onready var forward_ray = $ForwardRay

var target
var path = []
var begin
var end
var PreviousDest
var initPos
var timeToGo = true
var m = SpatialMaterial.new()
var draw_path = true
var nDraw = ImmediateGeometry.new()
var next_move_pos = Vector3(0,0,0)

func _update_path():
	initPos = global_transform.origin
	target = targets[rand_range(0, targets.size() -1)]
	var targetPos = target.global_transform.origin
	begin = nav.get_closest_point(self.get_translation())
	end = nav.get_closest_point(target.get_translation())
	if begin == end or begin.distance_to(end) < 1.5 or end == PreviousDest:
		target = targets[rand_range(0, targets.size() -1)]
		begin = nav.get_closest_point(self.get_translation())
		end = nav.get_closest_point(target.get_translation())
	var p = nav.a_GenPath(begin, end)
	path = Array(p)
	path.invert()
	
	if (draw_path):
		var im = nDraw
		im.set_material_override(m)
		im.clear()
		im.begin(Mesh.PRIMITIVE_POINTS, null)
		im.add_vertex(begin)
		im.add_vertex(end)
		im.end()
		im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		for x in p:
			im.add_vertex(x)
		im.end()
	pass


func _ready():
	randomize()
	forward_ray.enabled = true
	nDraw.name = "drawFrom" + str(self.name)
#	nav.add_child(nDraw)
	nav.call_deferred("add_child", nDraw)
	_update_path()
	
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.set_point_size(20)
	m.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
	pass


func aWalking(delta):
	var direction = Vector3(0,0,0)
	var initialTranslation = translation
#	if(path.size() > 0):
	if !path.empty():  # Same as above
		var next_position = path[path.size() - 1]
		if (next_move_pos == Vector3(0, 0, 0)):
			next_move_pos = next_position
		var distance = translation.distance_to(next_position)
		if(distance != 0):
			next_position = translation.linear_interpolate(next_position, (speed*delta)/distance)
		direction = next_position - translation;
		direction.normalized()
		look_at(Vector3(next_move_pos.x, initialTranslation.y, next_move_pos.z) + Vector3(direction.x, 0, direction.z),Vector3(0, 1, 0))
#		mvandcol_teste = move_and_collide(direction * speed, true, true, true)
		var onTheWay = move_and_slide(direction * speed, Vector3(0, 1, 0))
		if onTheWay == null:
			print("Saporra parou...")
		if(abs(translation.x - next_move_pos.x) <= 0.7 and abs(translation.z - next_move_pos.z) <= 0.7):
			path.remove(path.size() - 1)
			next_move_pos = Vector3(0,0,0)
		if path.size() == 1:
			PreviousDest = end
	if(path.size() == 0 and timeToGo):
		set_TimeToGo()
	pass


func _physics_process(delta):
	aWalking(delta)
	pass


func set_TimeToGo():
	timeToGo = false
	timer.wait_time = 2.0
	timer.start()
	pass


func _on_Timer_timeout():
	timeToGo = true
	_update_path()
	pass
