extends TextureRect
var subject

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	subject = get_tree().get_nodes_in_group("player")[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_up_pressed():
	subject.burn()
	pass # Replace with function body.


func _on_left_pressed():
	subject.rotate_left()
	pass # Replace with function body.


func _on_right_pressed():
	subject.rotate_right()
	pass # Replace with function body.
