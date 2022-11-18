extends RigidBody2D
var state = "idle"
var current_motion
var current_gravity
export var mass_fudge = 1.0
export var multi = 30
var mother_star
var star
var stargrav
var starangle
export var object_name = "Asteroid"
export var resource_type = 0
export var gravity_set = 40


# Called when the node enters the scene tree for the first time.
func _ready():
	star = get_tree().get_nodes_in_group("star")[0]
	stargrav = star.get_node("gravity")
	var push = Vector2(0, orbit_calculate(stargrav))
	var starangle = star.get_global_position().angle_to_point(get_global_position())
	var push_rotated = push.rotated(starangle)
	set_linear_velocity(push_rotated * multi)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_colliding_bodies() and state == "idle":
		state = "free"
		set_as_toplevel(true)
		set_sleeping(false)
	for item in $damage.get_overlapping_areas():
		if item.is_in_group("corona"):
			queue_free()

func _integrate_forces(state):
	pass


func orbit_calculate(target):
	var g = target.get_gravity()
	var m = mass_fudge
	var r = position.distance_to(target.position)
	return sqrt(g * m / 1)
