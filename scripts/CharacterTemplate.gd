extends KinematicBody

# Constants
const GRAVITY = 9.8

# Physics
export(float, 10.0, 30.0) var speed = 15.0
export(float, 10.0, 50.0) var jump_height = 25.0
export(float, 1.0, 10.0) var mass = 8.0
export(float, 0.1, 3.0, 0.1) var gravity_scl = 1.0

onready var ground_ray = $GroundRay

var gravity_speed = 0
var walking = false
var rayCollider


func _ready():
	pass


func _physics_process(delta):
	# Gravity
	gravity_speed -= GRAVITY * gravity_scl * mass * delta
	
	var velocity = Vector3()
	velocity.y = gravity_speed
	gravity_speed = move_and_slide(velocity, ground_ray.get_collision_normal(), true).y
	
