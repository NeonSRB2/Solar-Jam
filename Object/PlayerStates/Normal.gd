extends Node
onready var parent = get_parent().get_parent()

# Called every tic
func state_process(delta):
	parent.movement.y -= 1 # gravity. given.
	
	var accel = 0.5
	if parent.ground:
		accel = 1
	parent.movement.x += parent.stick.x*accel
	parent.movement.z += parent.stick.y*accel
	parent.movement.x *= 0.95
	parent.movement.z *= 0.95
	
	# boing !!
	print(parent.ground)
	if parent.jumpInput == 1 and parent.ground:
		parent.movement *= 2
		parent.movement.y = 20
