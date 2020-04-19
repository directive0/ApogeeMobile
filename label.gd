extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = get_parent().get_position()
	target.y += 55
	target.x -= (get_size().x/2)
	set_position(target)

#	pass
