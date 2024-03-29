extends Control
export(int, "velocity", "damage", "fuel") var indicator_type
var subject

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func velocity():
	subject = get_tree().get_nodes_in_group("player")[0]
	var speed = sqrt(pow(subject.current_motion[0],2)+pow(subject.current_motion[1],2))
	if has_node("progress/label"):
		$progress/label.set_text(str(int(speed)))
	if has_node("progress"):
		$progress.value = speed

func fuel():
	subject = get_tree().get_nodes_in_group("player")[0]
	if has_node("progress/label"):
		$progress/label.set_text(str(subject.fuel))
	if has_node("progress"):
		$progress.value = subject.fuel
#	pass
func damage():
	subject = get_tree().get_nodes_in_group("player")[0]
	if has_node("progress/label"):
		$progress/label.set_text(str(subject.hull))
	if has_node("progress"):
		$progress.value = subject.hull



func _process(delta):
	if is_network_master():
		if indicator_type == 0:
			velocity()
		if indicator_type == 1:
			damage()
		if indicator_type == 2:
			fuel()
