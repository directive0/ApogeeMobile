extends Node2D
var subject
var camera
var targets
var target
var default
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if is_network_master():
		visible = true
		pass

	default = get_scale()
	subject = get_parent()
	camera = subject.get_node("Camera2D")
	set_as_toplevel(true)
	pass # Replace with function body.

func pointing():
	return subject.get_rotation()


func target():
	pass

func heading():
	var motion = subject.motion
	var origin = Vector2()
	print(subject)
	var rotater = motion.angle_to_point(origin)
	return rotater

func gravity():
	var gravity = subject.gravity.normalized()
	var origin = Vector2()
	var rotater = gravity.angle_to_point(origin)
	return rotater

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	set_position(subject.position) 

	# Keeps the indicator information from being called if the computer we are on is not the owner of this node
	if is_network_master():
		$heading.set_rotation(heading())
		$arrow.set_rotation(pointing())
		$gravity.set_rotation(gravity())

	
	#turns the heading arrow on when zoomed out, and removes it when zoomed in
	if camera.get_zoom().y > 6:
		$arrow.set_visible(true)
		set_scale((camera.get_zoom() / Vector2(6,6)) * default)
	else:
		$arrow.set_visible(false)
		set_scale(default)

