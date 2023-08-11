extends Area2D


var speed = 1.0
var x_position = 1083
var y_position_min = 89
var y_position_max = 207

func _ready():
	position.x = 1083
	position.y = 95

func _physics_process(delta):
	move()

func move():
	if position.y < y_position_min:
		move_down()
	else:
		move_up()
#	if position.y <= y_position_min:
#		move_down()
#	if position.y >= y_position_max:
#		move_up()

func move_up():
	if position.y >= y_position_min:
		position.y -= speed
	
func move_down():
	if position.y <= y_position_max:
		position.y += speed
