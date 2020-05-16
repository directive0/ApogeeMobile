extends VBoxContainer
export(int, "velocity", "damage", "fuel") var indicator_type
var subject

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func velocity():
	subject = get_tree().get_nodes_in_group("player")[0]
	$label.set_text(str(sqrt(pow(subject.current_motion[0],2)+pow(subject.current_motion[1],2))))

func fuel():
	subject = get_tree().get_nodes_in_group("player")[0]
	$label.set_text(str(subject.fuel))
	if has_node("ProgressBar"):
		$ProgressBar.value = subject.fuel
#	pass
func damage():
	subject = get_tree().get_nodes_in_group("player")[0]
	$label.set_text(str(subject.hull))
	if has_node("ProgressBar"):
		$ProgressBar.value = subject.hull
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if is_network_master():
		if indicator_type == 0:
			velocity()
		if indicator_type == 1:
			damage()
		if indicator_type == 2:
			fuel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
