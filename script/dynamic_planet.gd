extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().get_nodes_in_group("star").size() > 0:
		#var angle = global_position.angle_to(get_tree().get_nodes_in_group("star")[0].global_position)
		#var angle = get_tree().get_nodes_in_group("star")[0].global_position.angle_to(global_position) + 3.14159
		var angle = get_angle_to(get_tree().get_nodes_in_group("star")[0].global_position)
		$shadow_pivot.set_global_rotation(angle)
		print(angle)

#	pass
