extends RigidBody2D

# Basic player script with Network calls

const MOTION_SPEED = 90.0

# these variables define the position of this object for all other peers
slave var slave_pos = Vector2()
slave var slave_motion = 0
slave var slave_rotation = 0.0


var engine_on = false
var slv_engine_on = false

export var stunned = false
export var test = false

var zoom = 1
var zoom_grain = 10
var max_zoom = 400
var min_zoom = 0.01

var vostok_hull = load("res://ships/vostok.tscn")
var dragon_hull = load("res://ships/dragon.tscn")

var ship_name = ""
var ship_type = "Vostok"

var gravity
var motion
var target
var current_motion 

# Use sync because it will be called everywhere
sync func setup_bomb(bomb_name, pos, by_who):
	var bomb = preload("res://station.tscn").instance()
	bomb.set_name(bomb_name) # Ensure unique name for the bomb
	bomb.position = pos
	bomb.from_player = by_who
	bomb.rotation = rotation + deg2rad(90)
	bomb.linear_velocity = current_motion
	
	
	# No need to set network mode to bomb, will be owned by master by default
	get_node("../..").add_child(bomb)

var current_anim = ""
var prev_bombing = false
var bomb_index = 0

func change_shiptype(ship):
	if ship == "Vostok":
		add_child(vostok_hull.instance())
		
	if ship == "Dragon":
		add_child(dragon_hull.instance())
	

func _ready():
	# checks to see if we are on the computer that is actually in control of this node.
	if is_network_master():
		$Camera2D.add_to_group("camera")

	change_shiptype(ship_type)

	$hull/plume.set_visible(false)
	stunned = false
	slave_pos = position



func rotate_player():
	var rotation = 0.0
	if Input.is_action_pressed("move_left"):
		rotation = -10
	if Input.is_action_pressed("move_right"):
		rotation = 10
		
	return rotation
	
func throttle():
	
	if engine_on:
		$hull/plume.set_visible(true)
	else:
		$hull/plume.set_visible(false)
		
	
func move_player():
	var motion = 0
	engine_on = false

	if Input.is_action_pressed("move_up"):
		motion += 3
		engine_on = true
		
	if Input.is_action_pressed("move_down"):
		motion += -3
		
	return motion

func zoom(delta):
	var zoomit = zoom_grain * ((zoom*.10) * delta)
	if zoom < min_zoom:
		zoom = min_zoom
	if zoom > max_zoom:
		zoom = max_zoom
	
	var adjust = Vector2(zoom,zoom)
	if Input.is_action_pressed("zoom_out"):
		zoom += zoomit
	if Input.is_action_pressed("zoom_in"):
		zoom -= zoomit
	
	$Camera2D.set_zoom(adjust)

func animate(motion):
	var new_anim = "standing"
	if motion.y < 0:
		new_anim = "walk_up"
	elif motion.y > 0:
		new_anim = "walk_down"
	elif motion.x < 0:
		new_anim = "walk_left"
	elif motion.x > 0:
		new_anim = "walk_right"

		
	if stunned:
		new_anim = "stunned"
		
	if new_anim != current_anim:
		current_anim = new_anim
		get_node("anim").play(current_anim)

func _integrate_forces(state):
	current_motion = state.get_linear_velocity()
	
	
	if not is_network_master():
		position = slave_pos
		set_rotation(slave_rotation)
	else:
		gravity = state.get_total_gravity() 
		motion = state.get_linear_velocity()

func _physics_process(delta):
	var motion = 0.0
	var torque = 0.0
	zoom(delta)
	
	if is_network_master():
		$Camera2D._set_current(true)
		motion = move_player()
		torque = rotate_player()

		# handles weapons --------------------------------------------------------
		var bombing = Input.is_action_pressed("set_bomb")

		#if stunned:
			#bombing = false
			#motion = 0.0	

		#Checks to see if a bomb is not already being deployed
		if bombing and not prev_bombing:
			#if not then make a new bomb with a name made of the ships name and the unique ID of the bomb
			var bomb_name = get_name() + str(bomb_index)
			print(bomb_name)
			#var facing = 
			var bomb_pos = position
			var bomb_rot = rotation
			rpc("setup_bomb", bomb_name, bomb_pos, get_tree().get_network_unique_id())

		prev_bombing = bombing
		# ------------------------------------------------------------------------
		
		# transfer the information for this ship to the server info to be used for puppets on other machines
		rset("slave_motion", motion)
		rset("slave_pos", position)
		rset("slave_rotation", get_rotation())
		rset("slv_engine_on", engine_on)
	else:
		position = slave_pos
		set_rotation(slave_rotation)
		motion = slave_motion
		engine_on = slv_engine_on
		rotation = slave_rotation
	throttle()
		#
	#animate(motion)
	
	var motioned = Vector2(motion,0).rotated(get_rotation()) 



	apply_impulse(Vector2(0,0), motioned)
	apply_torque_impulse(torque)
	
	if not is_network_master():
		slave_pos = position # To avoid jitter

slave func stun():
	stunned = true

master func exploded(by_who):
	if stunned:
		return
	rpc("stun") # Stun slaves
	stun() # Stun master - could use sync to do both at once

func set_player_name(new_name,shiptype = "Vostok"):
	get_node("label").set_text(new_name)
	ship_type = shiptype

