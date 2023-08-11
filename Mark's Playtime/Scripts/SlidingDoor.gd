extends KinematicBody2D

var x_position = 1043
var y_position_min = 89
var y_position_max = 207
var Velocity = Vector2.ZERO
var speed = 200

func _ready():
#	position.x = 1043
	pass

func _physics_process(delta):
	move()

func move():
	if position.y > y_position_min:
		move_up()
	else:
		move_down()

func move_up():
	Velocity.y -= 2
	Velocity = move_and_slide(Velocity, Vector2(0, -1), false)
#	Velocity = move_and_collide(Velocity)

func move_down():
	Velocity.y += 2
	Velocity = move_and_slide(Velocity, Vector2(0, -1), false)
#	Velocity = move_and_collide(Velocity)
