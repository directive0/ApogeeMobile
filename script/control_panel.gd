extends CanvasLayer

var subject

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#disables touch UI elements.
	if gamestate.device_type == 0:
		var ui = get_tree().get_nodes_in_group("touch_ui")
		for uis in ui:
			uis.queue_free()
	#print(get_tree().get_nodes_in_group("player"))

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if is_network_master():
	#	subject = get_tree().get_nodes_in_group("player")[0]
	#	$Control/VBoxContainer/topbar/HBoxContainer/Indicator/label.set_text(str(sqrt(pow(subject.current_motion[0],2)+pow(subject.current_motion[1],2))))
#	pass
