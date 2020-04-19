extends RigidBody2D

var in_area = []
var from_player
var fuel = 100

# Called from the animation
func explode():
	if not is_network_master():
		# But will call explosion only on master
		return
	for p in in_area:
		if p.has_method("exploded"):
			p.rpc("exploded", from_player) # Exploded has a master keyword, so it will only be received by the master

func _physics_process(delta):
	var motioned = Vector2(-10,0).rotated(get_rotation() - deg2rad(-90))
	if fuel != 0:
		apply_impulse(Vector2(0,0), motioned)
		fuel -= 1
		


func done():
	queue_free()

func _on_bomb_body_enter(body):
	if not body in in_area:
		in_area.append(body)

func _on_bomb_body_exit(body):
	in_area.erase(body)


func _on_Area2D_body_entered(body):
	if not body in in_area:
		in_area.append(body)


func _on_Area2D_body_exited(body):
	in_area.erase(body)
