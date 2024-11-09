extends KinematicBody

# basic states stuff
# i plan on climbing existing so...
onready var stateNode = $STATES
onready var currentState = stateNode.get_child(0)

var ground = false
var movement = Vector3.ZERO
var stick = Vector2.ZERO # the position of the left joystick
var jumpInput = 0
var actionInput = 0

var areaObjects = []
var areaSelected = self # self is if there is no area to interact vvith

func _on_SELECTABLE_area_entered(area):
	if !areaObjects.has(area):
		areaObjects.append(area)

func _on_SELECTABLE_area_exited(area):
	if areaObjects.has(area):
		areaObjects.erase(area)


# general process
func _physics_process(delta):
	# get stick input, since i might need to change vvhat feeds this later
	stick.x = Input.get_joy_axis(0, 0)
	stick.y = Input.get_joy_axis(0, 1)
	# get jump Input
	# (-inf, 0] is release
	# [1, inf) is press
	# value increases or decreases by 1 every tic depending on it
	# think that one srb2 lua lib for input
	if Input.is_action_pressed("ui_accept"):
		jumpInput = max(1, jumpInput + 1)
	else:
		jumpInput = min(0, jumpInput - 1)
	print(jumpInput)
	
	# figure out that select area
	var closestObject = self
	var objectdist = 654365346534 # impossible
	for i in areaObjects:
		var distpos = i.global_position - global_position
		distpos.x *= distpos.x # square them all for pythagoreas
		distpos.y *= distpos.y
		distpos.z *= distpos.z # you can add extra dimensions to pt just fine vvithout extra sqrt
		var dist = distpos.x + distpos.y + distpos.z # add them up
		if dist <= objectdist: # actually, you don't even need the sqrt, c^2 is just fine for comparisons like this
			closestObject = i
			objectdist = dist
	areaSelected = closestObject # set to self if found nothing
	print(areaSelected.name)
	print(areaObjects)
	if areaSelected != self:
		$SELECTICON.visible = true
		$SELECTICON.global_position = areaSelected.global_position
	else:
		$SELECTICON.visible = false
	
	# states!
	currentState.state_process(delta)
	
	# collision shits
	ground = false
	movement = move_and_slide(movement)
	for i in range(get_slide_count()):
		var slide = get_slide_collision(i)
		print(slide.normal)
		if slide.normal.y >= 0.6:
			ground = true
